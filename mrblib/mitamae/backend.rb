module MItamae
  class Backend
    CommandExecutionError = Class.new(StandardError)

    def initialize(options = {})
      @shell = options.fetch(:shell, '/bin/sh')
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L46-L86
    def run_command(commands, options = {})
      options = { error: true }.merge(options)

      command = build_command(commands, options)
      MItamae.logger.debug "Executing `#{command}`..."

      result = spawn_command(command)

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

    # https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/base.rb#L27-L36
    def os_info
      return @os_info if @os_info
      Specinfra::Helper::DetectOs.all.each do |klass|
        if @os_info = klass.new(self).detect
          @os_info[:arch] ||= run_command('uname -m').stdout.strip
          return @os_info
        end
      end
      raise 'Failed to detect OS!'
    end

    # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/backend.rb#L88-L90
    # https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/base.rb#L38-L40
    def get_command(*args)
      Specinfra::CommandFactory.new(os_info).get(*args)
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

    # https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/exec.rb#L56-L141
    def spawn_command(cmd)
      stdout, stderr, status = Open3.capture3(@shell, '-c', cmd)
      CommandResult.new(stdout: stdout, stderr: stderr, exit_status: status.exitstatus)
    end
  end
end
