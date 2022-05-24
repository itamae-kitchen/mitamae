# Wrapper of Specinfra used by not only ResourceExecutor but also MItamae::Node.
module MItamae
  class Backend
    CommandExecutionError = Class.new(StandardError)

    def initialize(shell: '/bin/sh')
      @shell = shell
      @backend = Specinfra::Backend::Exec.new(shell: @shell)
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L46-L86
    def run_command(command, error: true, user: nil, cwd: nil, log_output: false)
      command_for_display = build_command(command, user: user, cwd: cwd)
      MItamae.logger.debug "Executing `#{command_for_display}`..."

      stdout, stderr, status = run_command_with_log_output(
        command,
        user: user,
        cwd: cwd,
        log_output: log_output,
      )

      MItamae.logger.with_indent do
        if status.exitstatus == 0 || !error
          MItamae.logger.debug("exited with #{status.exitstatus}")
        else
          unless log_output
            stdout.each_line do |line|
              log_output_line(:error, 'stdout', line)
            end
            stderr.each_line do |line|
              log_output_line(:error, 'stderr', line)
            end
          end
          MItamae.logger.error("Command `#{command_for_display}` failed. (exit status: #{status.exitstatus})")
        end
      end

      if error && status.exitstatus != 0
        raise CommandExecutionError
      end

      Specinfra::CommandResult.new(stdout: stdout, stderr: stderr, exit_status: status.exitstatus)
    end

    def get_command(*args)
      @backend.command.get(*args)
    end

    def host_inventory
      @backend.host_inventory
    end

    private

    def log_output_line(level, output_name, line)
      line = line.gsub(/[[:cntrl:]]/, '')
      MItamae.logger.send(level, "#{output_name} | #{line}")
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L168-L189
    def build_command(command, user: nil, cwd: nil)
      if command.is_a?(Array)
        command = Shellwords.shelljoin(command)
      end

      if cwd
        command = "cd #{cwd.shellescape} && #{command}"
      end

      if user
        command = "cd ~#{user.shellescape} ; #{command}"
        command = "sudo -H -u #{user.shellescape} -- #{@shell.shellescape} -c #{command.shellescape}"
      end

      command
    end

    def run_command_with_log_output(command, user:, cwd:, log_output:)
      spawn_opts = {}
      if user
        # Cannot emulate `:user` option without the shell. Fallback to the slow version.
        command = [@shell, '-c', build_command(command, cwd: cwd, user: user)]
      else
        if command.is_a?(String)
          command = [@shell, '-c', command]
        end

        if cwd
          spawn_opts[:chdir] = cwd
        end
      end
      log_level = (log_output ? :info : :debug)

      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe
      spawn_opts[:out] = out_w.to_i
      spawn_opts[:err] = err_w.to_i

      pid = Open3.spawn(*command, spawn_opts)

      out_w.close
      err_w.close

      stdout = ''
      stderr = ''

      remaining_ios = [out_r, err_r]
      until remaining_ios.empty?
        readable_ios, = IO.select(remaining_ios)
        readable_ios.each do |io|
          begin
            line = io.readline
            if io == out_r
              log_output_line(log_level, 'stdout', line)
              stdout << line
            else
              log_output_line(log_level, 'stderr', line)
              stderr << line
            end
          rescue EOFError
            io.close unless io.closed?
            remaining_ios.delete(io)
          end
        end
      end

      _, status = Process.waitpid2(pid)
      [stdout, stderr, status]
    end
  end
end
