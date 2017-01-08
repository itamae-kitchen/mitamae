module MItamae
  class ResourceContext
    def initialize(resource, variables = {})
      @resource = resource
      variables.each do |key, value|
        if value.is_a?(Proc)
          define_singleton_method(key, &value)
        else
          define_singleton_method(key) { value }
        end
      end
    end

    def notifies(action, resource_desc, timing = :delay)
      @resource.notifications << Notification.create(@resource, action, resource_desc, timing)
    end

    def subscribes(action, resource_desc, timing = :delay)
      @resource.subscriptions << Subscription.create(@resource, action, resource_desc, timing)
    end

    def not_if(command = nil, &block)
      if block
        @resource.not_if_command = block
      elsif command
        @resource.not_if_command = command
      else
        raise ArgumentError, 'not_if requires command or block'
      end
    end

    def only_if(command = nil, &block)
      if block
        @resource.only_if_command = block
      elsif command
        @resource.only_if_command = command
      else
        raise ArgumentError, 'only_if requires command or block'
      end
    end

    def verify(command)
      @resource.verify_commands << command
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
