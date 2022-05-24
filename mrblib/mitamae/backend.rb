# Wrapper of Specinfra used by not only ResourceExecutor but also MItamae::Node.
module MItamae
  class Backend
    CommandExecutionError = Class.new(StandardError)

    def initialize(shell: '/bin/sh')
      @shell = shell
      @backend = Specinfra::Backend::Exec.new(shell: @shell)
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L46-L86
    def run_command(commands, error: true, user: nil, cwd: nil, log_output: false)
      log_output_severity = if log_output
        :info
      elsif MItamae.logger.level == Logger::DEBUG
        :debug
      else
        nil
      end

      command_for_display = build_command(commands, user: user, cwd: cwd)
      MItamae.logger.debug "Executing `#{command_for_display}`..."

      stdout, stderr, status = run_with_open3(
        commands,
        user: user,
        cwd: cwd,
        log_output_severity: log_output_severity
      )

      MItamae.logger.with_indent do
        if status.exitstatus == 0 || !error
          method = :debug
          message = "exited with #{status.exitstatus}"
        else
          method = :error
          message = "Command `#{command_for_display}` failed. (exit status: #{status.exitstatus})"

          unless log_output
            stdout.each_line do |l|
              log_output_line(:error, "stdout", l)
            end
            stderr.each_line do |l|
              log_output_line(:error, "stderr", l)
            end
          end
        end
        MItamae.logger.send(method, message)
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
    def build_command(commands, user: nil, cwd: nil)
      if commands.is_a?(Array)
        command = Shellwords.shelljoin(commands)
      else
        command = commands
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

    def run_with_open3(commands, user: nil, cwd: nil, log_output_severity: nil)
      spawn_opts = {}
      if user
        # Cannot emulate `:user` option without the shell. Fallback to the slow version.
        commands = [@shell, '-c', build_command(commands, cwd: cwd, user: user)]
      else
        if commands.is_a?(String)
          commands = [@shell, '-c', commands]
        end

        if cwd
          spawn_opts[:chdir] = cwd
        end
      end

      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe
      spawn_opts[:out] = out_w.to_i
      spawn_opts[:err] = err_w.to_i

      pid = Open3.spawn(*commands, spawn_opts)

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
              log_output_line(log_output_severity, "stdout", line) if log_output_severity
              stdout << line
            else
              log_output_line(log_output_severity, "stderr", line) if log_output_severity
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
