module Itamae
  module ResourceExecutor
    class Group < Base
      def apply(current, desired)
        if desired.exist
          if exist?
            if attributes.gid && attributes.gid != current.gid
              run_specinfra(:update_group_gid, attributes.groupname, attributes.gid)
            end
          else
            options = {
              gid: attributes.gid
            }

            run_specinfra(:add_group, attributes.groupname, options)
          end
        end
      end

      private

      def set_current_attributes(current, action)
        current.exist = exist?

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

      def exist?
        run_specinfra(:check_group_exists, attributes.groupname)
      end
    end
  end
end
