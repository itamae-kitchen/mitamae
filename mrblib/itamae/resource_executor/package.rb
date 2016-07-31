module Itamae
  module ResourceExecutor
    class Package < Base
      def action_install
        attributes = @resource.attributes
        unless run_specinfra(:check_package_is_installed, attributes.name, attributes.version)
          run_specinfra(:install_package, attributes.name, attributes.version, attributes.options)
          updated!
        end
      end

      def action_remove
        attributes = @resource.attributes
        if run_specinfra(:check_package_is_installed, attributes.name, nil)
          run_specinfra(:remove_package, attributes.name, attributes.options)
          updated!
        end
      end

      private

      def set_current_attributes(attributes, action)
        case action
        when :install, :remove
          attributes.installed = run_specinfra(:check_package_is_installed, @resource.attributes.name)
        end
      end

      def set_desired_attributes(attributes, action)
        case action
        when :install
          attributes.installed = true
        when :remove
          attributes.installed = false
        end
      end
    end
  end
end
