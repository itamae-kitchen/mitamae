module Itamae
  module ResourceExecutor
    class Link < Base
      def action_create
        unless run_specinfra(:check_file_is_linked_to, attributes.link, attributes.to)
          run_specinfra(:link_file_to, attributes.link, attributes.to, force: attributes.force)
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
