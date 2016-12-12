module MItamae
  module InlineBackends
    class FileBackend
      def runnable?(type, *args)
        respond_to?(type)
      end

      def run(type, *args)
        send(type, *args)
      end

      def check_file_is_directory(path)
        FileTest.directory?(path)
      end

      def get_file_mode(path)
        mode_str = sprintf('%04o', File.stat(path).mode & 07777)
        Specinfra::CommandResult.new(stdout: mode_str, stderr: '', exit_status: 0)
      rescue => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end
    end
  end
end
