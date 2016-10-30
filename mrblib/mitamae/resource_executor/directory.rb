module MItamae
  module ResourceExecutor
    class Directory < Base
      def apply(_, desired)
        if desired.exist
          if !run_specinfra(:check_file_is_directory, desired.path)
            run_specinfra(:create_file_as_directory, desired.path)
          end
          if desired.mode
            run_specinfra(:change_file_mode, desired.path, desired.mode)
          end
          if desired.owner || desired.group
            run_specinfra(:change_file_owner, desired.path, desired.owner, desired.group)
          end
        else
          if run_specinfra(:check_file_is_directory, desired.path)
            run_specinfra(:remove_file, desired.path)
          end
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

      def normalize_mode(mode)
        sprintf("%4s", mode).gsub(/ /, '0')
      end

      def show_differences(current, desired)
        current.mode = normalize_mode(current.mode) if current.mode
        desired.mode = normalize_mode(desired.mode) if desired.mode

        super
      end
    end
  end
end
