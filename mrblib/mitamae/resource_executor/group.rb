module MItamae
  module ResourceExecutor
    class Group < Base
      def apply
        if desired.exist
          if exist?(desired.groupname)
            if desired.gid && desired.gid != current.gid
              run_specinfra(:update_group_gid, desired.groupname, desired.gid)
            end
          else
            options = {
              gid: desired.gid
            }

            run_specinfra(:add_group, desired.groupname, options)
          end
        end
      end

      private

      def set_current_attributes(current, action)
        current.exist = exist?(attributes.groupname)

        if current.exist
          current.gid = run_specinfra(:get_group_gid, attributes.groupname).stdout.strip.to_i
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        end
      end

      def exist?(groupname)
        run_specinfra(:check_group_exists, groupname)
      end
    end
  end
end
