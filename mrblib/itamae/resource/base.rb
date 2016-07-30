module Itamae
  module Resource
    class Base
      class << self
        attr_reader :default_name
        attr_reader :defined_attributes

        def define_attribute(name, options = {})
          @defined_attributes ||= {}

          options = options.dup
          if options.delete(:default_name)
            @default_name = name.to_sym
          end
          @defined_attributes[name.to_sym] = options
        end
      end

      attr_accessor :attributes

      def initialize(default_name, &block)
        @attributes = {}
        @attributes[self.class.default_name] = default_name
        if block
          ResourceContext.new(self).instance_exec(&block)
        end
      end
    end
  end
end
