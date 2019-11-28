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
      rescue SystemCallError => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end

      def change_file_mode(path, mode_str)
        File.chmod(mode_str.to_i(8), path)
        Specinfra::CommandResult.new(stdout: '', stderr: '', exit_status: 0)
      rescue SystemCallError => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end

      def get_file_owner_user(path)
        uid = File.stat(path).uid
        passwd = Etc.getpwuid(uid)
        result = passwd ? passwd.name : 'UNKNOWN'
        Specinfra::CommandResult.new(stdout: result, stderr: '', exit_status: 0)
      rescue SystemCallError => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end

      def get_file_owner_group(path)
        gid = File.stat(path).gid
        group = Etc.getgrgid(gid)
        result = group ? group.name : 'UNKNOWN'
        Specinfra::CommandResult.new(stdout: result, stderr: '', exit_status: 0)
      rescue SystemCallError => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end

      def check_file_is_link(path)
        File.symlink?(path)
      end

      def get_file_link_target(path)
        target = File.readlink(path)
        Specinfra::CommandResult.new(stdout: target, stderr: '', exit_status: 0)
      rescue SystemCallError => e
        Specinfra::CommandResult.new(stdout: '', stderr: e.message, exit_status: 1)
      end

      def check_file_is_linked_to(link, target)
        File.readlink(link) == target
      rescue SystemCallError
        false
      end
    end
  end
end
