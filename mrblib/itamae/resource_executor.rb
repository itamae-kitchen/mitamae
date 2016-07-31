module Itamae
  module ResourceExecutor
    NotFoundError = Class.new(StandardError)

    class << self
      def find(resource_class)
        class_name = resource_class.to_s
        if class_name.start_with?('Itamae::Resource::')
          const_get(class_name.sub(/\AItamae::Resource::/, ''))
        else
          raise NotFoundError, "executor not found for '#{class_name}'"
        end
      end
    end
  end
end
