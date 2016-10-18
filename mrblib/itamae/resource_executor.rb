module Itamae
  module ResourceExecutor
    NotFoundError = Class.new(StandardError)

    class << self
      def create(resource, options)
        find(resource.class).new(resource, options)
      end

      private

      def find(resource_class)
        class_name = resource_class.to_s
        if class_name.start_with?('Itamae::Resource::')
          const_get(class_name.sub(/\AItamae::Resource::/, ''))
        elsif Plugin::Resource.resource_plugin?(class_name)
          Plugin::ResourceExecutor.find(resource_class)
        else
          raise NotFoundError, "executor not found for '#{class_name}'"
        end
      end
    end
  end
end
