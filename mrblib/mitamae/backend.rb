# Wrapper of Specinfra used by not only ResourceExecutor but also MItamae::Node.
module MItamae
  class Backend
    CommandExecutionError = Class.new(StandardError)

    def initialize(options = {})
      @shell = options.fetch(:shell, '/bin/sh')
      @backend = Specinfra::Backend::Exec.new(shell: @shell)
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L46-L86
    def run_command(commands, options = {})
      options = { error: true }.merge(options)

      command = build_command(commands, options)
      MItamae.logger.debug "Executing `#{command}`..."

      result = @backend.run_command(command)

      MItamae.logger.with_indent do
        flush_buffers(result.stdout, result.stderr)

        if result.exit_status == 0 || !options[:error]
          method = :debug
          message = "exited with #{result.exit_status}"
        else
          method = :error
          message = "Command `#{command}` failed. (exit status: #{result.exit_status})"

          unless MItamae.logger.level == Logger::DEBUG
            result.stdout.each_line do |l|
              log_output_line("stdout", l)
            end
            result.stderr.each_line do |l|
              log_output_line("stderr", l)
            end
          end
        end
        MItamae.logger.send(method, message)
      end

      if options[:error] && result.exit_status != 0
        raise CommandExecutionError
      end

      result
    end

    def get_command(*args)
      @backend.command.get(*args)
    end

    def host_inventory
      @backend.host_inventory
    end

    private

    def flush_buffers(stdout, stderr)
      unless stdout.empty?
        MItamae.logger.debug("stdout | #{stdout}")
      end
      unless stderr.empty?
        MItamae.logger.debug("stderr | #{stderr}")
      end
    end

    def log_output_line(output_name, line)
      line = line.gsub(/[[:cntrl:]]/, '')
      MItamae.logger.error("#{output_name} | #{line}")
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
  end
end
