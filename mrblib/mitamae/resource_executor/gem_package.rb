module MItamae
  module ResourceExecutor
    class GemPackage < Base
      def apply(current, desired)
        if desired.installed
          if current.installed
            if desired.version && current.version != desired.version
              install!
              updated!
            end
          else
            install!
            updated!
          end
        elsif desired.upgraded
          return if current.installed && desired.version && current.version == desired.version

          install!
          updated!
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :install, :upgrade
          installed = installed_gems.find {|g| g[:name] == attributes.package_name }
          current.installed = !!installed

          if current.installed
            versions = installed[:versions]
            if versions.include?(attributes.version)
              current.version = attributes.version
            else
              current.version = versions.first
            end
          end
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :install
          desired.installed = true
        when :upgrade
          desired.upgraded = true
        end
      end

      def installed_gems
        gems = []
        run_command([*Array(attributes.gem_binary), 'list', '-l']).stdout.each_line do |line|
          if /\A([^ ]+) \(([^\)]+)\)\z/ =~ line.strip
            name = $1
            versions = $2.split(', ')
            gems << {name: name, versions: versions}
          end
        end
        gems
      rescue Backend::CommandExecutionError
        []
      end

      def install!
        cmd = [*Array(attributes.gem_binary), 'install', *Array(attributes.options)]
        if attributes.version
          cmd << '-v' << attributes.version
        end
        if attributes.source
          cmd << '--source' << attributes.source
        end
        cmd << attributes.package_name

        run_command(cmd)
      end
    end
  end
end
