module Itamae
  module Plugin
    # Define resource plugins under `Itamae::Plugin::Resource::`.
    module Resource
      def self.resource_plugin?(klass)
        klass.to_s =~ /\AItamae::Plugin::Resource::[a-zA-Z\d]+\z/
      end
    end

    # Define resource executor plugins under `Itamae::Plugin::ResourceExecutor::`.
    module ResourceExecutor
      def self.find(klass)
        const_get(klass.to_s.sub(/\AItamae::Plugin::Resource::/, ''))
      end
    end
  end
end
