module MItamae
  module ResourceExecutor
    class User < Base
      def apply(current, desired)
        if desired.exist
          if current.exist
            if desired.uid && desired.uid != current.uid
              run_specinfra(:update_user_uid, desired.username, desired.uid)
            end

            if desired.gid && desired.gid != current.gid
              run_specinfra(:update_user_gid, desired.username, desired.gid)
            end

            if desired.password && desired.password != current.password
              run_specinfra(:update_user_encrypted_password, desired.username, desired.password)
            end

            if desired.home && desired.home != current.home
              run_specinfra(:update_user_home_directory, desired.username, desired.home)
            end

            if desired.shell && desired.shell != current.shell
              run_specinfra(:update_user_login_shell, desired.username, desired.shell)
            end
          else
            options = {
              gid:            desired.gid,
              home_directory: desired.home,
              password:       desired.password,
              system_user:    desired.system_user,
              uid:            desired.uid,
              shell:          desired.shell,
              create_home:    desired.create_home,
            }

            run_specinfra(:add_user, desired.username, options)
          end
        end
      end

      private

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        end

        if attributes.gid.is_a?(String)
          # convert name to gid
          desired.gid = run_specinfra(:get_group_gid, attributes.gid).stdout.to_i
        end
      end

      def set_current_attributes(current, action)
        current.exist = exist?(attributes.username)

        if current.exist
          current.uid = run_specinfra(:get_user_uid, attributes.username).stdout.strip.to_i
          current.gid = run_specinfra(:get_user_gid, attributes.username).stdout.strip.to_i
          current.home = run_specinfra(:get_user_home_directory, attributes.username).stdout.strip
          current.shell = run_specinfra(:get_user_login_shell, attributes.username).stdout.strip
          current.password = current_password
        end
      end

      def current_password
        result = run_specinfra(:get_user_encrypted_password, attributes.username)
        if result.success?
          result.stdout.strip
        else
          nil
        end
      end

      def exist?(username)
        run_specinfra(:check_user_exists, username)
      end
    end
  end
end
