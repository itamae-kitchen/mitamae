module Itamae
  class Backend
    CommandExecutionError = Class.new(StandardError)

    def initialize(options = {})
      @shell = options.fetch(:shell, '/bin/sh')
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L46-L86
    def run_command(commands, options = {})
      options = { error: true }.merge(options)

      command = build_command(commands, options)
      Itamae.logger.debug "Executing `#{command}`..."

      result = spawn_command(command)

      Itamae.logger.with_indent do
        flush_buffers(result.stdout, result.stderr)

        if result.exit_status == 0 || !options[:error]
          method = :debug
          message = "exited with #{result.exit_status}"
        else
          method = :error
          message = "Command `#{command}` failed. (exit status: #{result.exit_status})"
        end
        Itamae.logger.send(method, message)
      end

      if options[:error] && result.exit_status != 0
        raise CommandExecutionError
      end

      result
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L88-L90
    # https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/base.rb#L38-L40
    def get_command(*args)
      # XXX: detect OS properly
      os_info = { family: 'arch', release: nil, arch: 'x86_64' }
      Specinfra::CommandFactory.new(os_info).get(*args)
    end

    private

    def flush_buffers(stdout, stderr)
      unless stdout.empty?
        Itamae.logger.debug("stdout | #{stdout}")
      end
      unless stderr.empty?
        Itamae.logger.debug("stderr | #{stderr}")
      end
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L168-L189
    def build_command(commands, options)
      if commands.is_a?(Array)
        command = Shellwords.shelljoin(commands)
      else
        command = commands
      end

      cwd = options[:cwd]
      if cwd
        command = "cd #{cwd.shellescape} && #{command}"
      end

      user = options[:user]
      if user
        command = "cd ~#{user.shellescape} ; #{command}"
        command = "sudo -H -u #{user.shellescape} -- #{@shell.shellescape} -c #{command.shellescape}"
      end

      command
    end

    # https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/exec.rb#L56-L141
    def spawn_command(cmd)
      stdout, stderr, status = Open3.capture3(@shell, '-c', cmd)
      CommandResult.new(stdout: stdout, stderr: stderr, exit_status: status.exitstatus)
    end
  end
end
