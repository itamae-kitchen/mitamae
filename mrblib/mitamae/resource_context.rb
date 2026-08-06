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

    # NOTE: Do not move `method_missing` below `private`. See the same note in
    # node.rb.
    #
    # Since mruby 3.4.0, when a method is not found, the VM falls back to
    # `method_missing` but then checks the visibility of `method_missing`
    # itself, reporting the *originally called* name. A private
    # `method_missing` therefore turns `ctx.owner 'root'` into
    # `NoMethodError: private method 'owner' called` whenever the resource
    # context is reached through an explicit receiver. Attribute calls with an
    # implicit self, which is how recipes are usually written, keep working
    # because calling a private method that way is legitimate.
    def method_missing(method, *args, &block)
      if @resource.class.defined_attributes[method]
        smethod = method.to_s
        if args.size == 1
          return @resource.attributes[smethod] = args.first
        elsif args.size == 0 && block_given?
          return @resource.attributes[smethod] = block
        elsif args.size == 0
          return @resource.attributes[smethod]
        end
      end

      # TODO: build mruby with MRB_DEFAULT_METHOD_MISSING
      # super
      raise NoMethodError, "undefined method `#{method}' for #{self.class}"
    end

    private

    def respond_to_missing?(method, include_private = false)
      @resource.class.defined_attributes.has_key?(method) || super
    end
  end
end
