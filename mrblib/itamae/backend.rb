module Itamae
  class Backend
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
      result
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
        # XXX: shell escape and join
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

    # XXX: https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/backend/exec.rb#L56-L141
    # We have `pipe` in mruby-io, `fork` and `waitpid` in mruby-process, but no `exec` or `spawn`...
    # And mruby's `IO.popen` can't have options. So stderr is just printed.
    def spawn_command(cmd)
      stderr = '' # XXX: Fake stdout.
      stdout = IO.popen(cmd) { |pipe| pipe.read }
      CommandResult.new(stdout: stdout, stderr: stderr, exit_status: $?)
    end
  end
end
