module Itamae
  module Resource
    class Base
      class << self
        attr_reader :defined_attributes

        def define_attribute(name, options = {})
          @defined_attributes ||= {}
          @defined_attributes[name.to_s] = options
        end
      end

      def initialize(name, &block)
        @name = name
        instance_exec(&block) if block
      end
    end
  end
end
