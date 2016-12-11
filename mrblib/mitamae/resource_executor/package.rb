module MItamae
  module ResourceExecutor
    class Package < Base
      def apply
        if desired.installed
          unless run_specinfra(:check_package_is_installed, desired.name, desired.version)
            run_specinfra(:install_package, desired.name, desired.version, desired.options)
            updated!
          end
        else
          if current.installed
            run_specinfra(:remove_package, desired.name, desired.options)
            updated!
          end
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
