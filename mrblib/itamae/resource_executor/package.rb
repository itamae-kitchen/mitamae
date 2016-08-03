module Itamae
  module ResourceExecutor
    class Package < Base
      def action_install
        unless run_specinfra(:check_package_is_installed, attributes.name, attributes.version)
          run_specinfra(:install_package, attributes.name, attributes.version, attributes.options)
          updated!
        end
      end

      def action_remove
        if run_specinfra(:check_package_is_installed, attributes.name, nil)
          run_specinfra(:remove_package, attributes.name, attributes.options)
          updated!
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :install, :remove
          current.installed = run_specinfra(:check_package_is_installed, attributes.name)
          if current.installed
            current.version = run_specinfra(:get_package_version, attributes.name).stdout.strip
          end
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :install
          desired.installed = true
        when :remove
          desired.installed = false
        end
      end
    end
  end
end
