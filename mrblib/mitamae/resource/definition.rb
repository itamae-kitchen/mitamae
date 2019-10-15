module MItamae
  module Resource
    class Definition < Base
      def self.create_class(name, params)
        Class.new(self).tap do |klass|
          klass.define_attribute :action, default: :run
          params.each_pair do |key, value|
            klass.define_attribute key.to_sym, type: Object, default: value
          end

          # `define_method('resource_type') { name }` behaves weirdly
          attr_writer :resource_type
        end
      end
    end
  end
end
