module MItamae
  module Plugin
    # Load plugins/*/mrblib/**/*.rb before running recipes.
    # Put a plugin repository under plugins as git submodule or just copy it.
    def self.load_plugins
      if File.directory?('plugins')
        Dir.glob('plugins/*/mrblib/**/*.rb').sort.each do |source|
          eval File.read(source)
        end
      end
    end

    # Define resource plugins under `MItamae::Plugin::Resource::`.
    module Resource
      def self.resource_plugin?(klass)
        klass.to_s =~ /\AMItamae::Plugin::Resource::[a-zA-Z\d]+\z/
      end
    end

    # Define resource executor plugins under `MItamae::Plugin::ResourceExecutor::`.
    module ResourceExecutor
      def self.find(klass)
        const_get(klass.to_s.sub(/\AMItamae::Plugin::Resource::/, ''))
      end
    end
  end
end
