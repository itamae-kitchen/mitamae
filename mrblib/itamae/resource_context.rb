module Itamae
  class ResourceContext
    def initialize(resource)
      @resource = resource
    end

    private

    def respond_to_missing?(method, include_private = false)
      @resource.class.defined_attributes.has_key?(method) || super
    end

    def method_missing(method, *args, &block)
      if @resource.class.defined_attributes[method]
        if args.size == 1
          return @resource.attributes[method] = args.first
        elsif args.size == 0 && block_given?
          return @resource.attributes[method] = block
        elsif args.size == 0
          return @resource.attributes[method]
        end
      end

      super
    end
  end
end
