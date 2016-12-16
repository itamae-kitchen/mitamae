module MItamae
  module InlineBackends
    class UserBackend
      PRIVATE_METHODS = %i[get_passwd_entry]

      def runnable?(type, *args)
        !PRIVATE_METHODS.include?(type) && respond_to?(type)
      end

      def run(type, *args)
        send(type, *args)
      end

      def get_passwd_entry(user_name, &block)
        passwd = Etc.getpwnam(user_name)
        if passwd
          output = block.call(passwd)
          Specinfra::CommandResult.new(stdout: output, stderr: '', exit_status: 0)
        else
          Specinfra::CommandResult.new(stdout: '', stderr: '', exit_status: 1)
        end
      end

      def check_user_exists(user_name)
        Etc.getpwnam(user_name) != nil
      end

      def get_user_uid(user_name)
        get_passwd_entry(user_name) { |pw| pw.uid.to_s }
      end

      def get_user_gid(user_name)
        get_passwd_entry(user_name) { |pw| pw.gid.to_s }
      end

      def get_user_home_directory(user_name)
        get_passwd_entry(user_name) { |pw| pw.dir }
      end

      def get_user_login_shell(user_name)
        get_passwd_entry(user_name) { |pw| pw.shell }
      end

      def get_user_encrypted_password(user_name)
        get_passwd_entry(user_name) { |pw| pw.passwd }
      end
    end
  end
end
