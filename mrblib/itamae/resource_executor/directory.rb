module Itamae
  module ResourceExecutor
    class Directory < Base
      def action_create
        if !run_specinfra(:check_file_is_directory, attributes.path)
          run_specinfra(:create_file_as_directory, attributes.path)
        end
        if attributes.mode
          run_specinfra(:change_file_mode, attributes.path, attributes.mode)
        end
        if attributes.owner || attributes.group
          run_specinfra(:change_file_owner, attributes.path, attributes.owner, attributes.group)
        end
      end

      def action_delete
        if run_specinfra(:check_file_is_directory, attributes.path)
          run_specinfra(:remove_file, attributes.path)
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :create, :delete
          current.exist = run_specinfra(:check_file_is_directory, attributes.path)

          if current.exist
            current.mode = run_specinfra(:get_file_mode, attributes.path).stdout.chomp
            current.owner = run_specinfra(:get_file_owner_user, attributes.path).stdout.chomp
            current.group = run_specinfra(:get_file_owner_group, attributes.path).stdout.chomp
          else
            current.mode = nil
            current.owner = nil
            current.group = nil
          end
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        when :delete
          desired.exist = false
        end
      end
    end
  end
end
