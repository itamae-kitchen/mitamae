module Itamae
  module Resource
    class Base
      class << self
        attr_reader :defined_attributes

        def define_attribute(name, options = {})
          @defined_attributes ||= {}
          @defined_attributes[name.to_sym] = options
        end
      end

      attr_accessor :attributes

      def initialize(name, &block)
        @attributes = {}
        @name = name
        if block
          ResourceContext.new(self).instance_exec(&block)
        end
      end
    end
  end
end
