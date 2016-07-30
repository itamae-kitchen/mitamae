module Itamae
  module Resource
    AttributeMissingError = Class.new(StandardError)
    InvalidTypeError = Class.new(StandardError)

    class Base
      class << self
        attr_reader :defined_attributes

        def define_attribute(name, options = {})
          @defined_attributes ||= {}
          @defined_attributes[name.to_sym] = options.dup
        end
      end

      attr_accessor :attributes
      attr_reader :resource_name

      def initialize(resource_name, variables = {}, &block)
        @attributes = {}
        @resource_name = resource_name
        if block
          ResourceContext.new(self, variables).instance_exec(&block)
        end
        process_attributes
      end

      private

      def process_attributes
        self.class.defined_attributes.each_pair do |key, details|
          @attributes[key] ||= @resource_name if details[:default_name]
          @attributes[key] = details[:default] if details.has_key?(:default) && !@attributes.has_key?(key)

          if details[:required] && !@attributes.has_key?(key)
            raise AttributeMissingError, "'#{key}' attribute is required but it is not set."
          end

          if @attributes.has_key?(key) && details[:type]
            valid_type = [details[:type]].flatten.any? do |type|
              @attributes[key].is_a?(type)
            end
            unless valid_type
              raise Resource::InvalidTypeError, "#{key} attribute should be #{details[:type]}."
            end
          end
        end
      end
    end
  end
end
