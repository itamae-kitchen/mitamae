module MItamae
  module ResourceExecutor
    class Link < Base
      def apply
        unless run_specinfra(:check_file_is_linked_to, desired.link, desired.to)
          run_specinfra(:link_file_to, desired.link, desired.to, force: desired.force, no_dereference: desired.force)
        end
      end

      private

      def set_current_attributes(current, action)
        current.exist = run_specinfra(:check_file_is_link, attributes.link)

        if current.exist
          current.to = run_specinfra(:get_file_link_target, attributes.link).stdout.strip
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        end
      end
    end
  end
end
