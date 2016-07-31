module Itamae
  module Executor
    class Base
      def initialize(resource, options)
        @resource = resource
        @shell    = options[:shell]
        @dry_run  = options[:dry_run]
      end

      def execute
        # check if
        [@resource.attributes[:action]].flatten.each do |action|
          run_action(action)
        end
        # verify
        # if updated?
        #   runner.diff_found!
        #   notify
        #   runner.handler.event(:resource_updated)
        # end
      end

      def action_nothing
        # noop
      end

      private

      def run_action(action)
        Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] action: #{action}"

        # pre_action
        # set_current_attributes
        # show_differences

        method_name = "action_#{action}"
        if @dry_run
          unless respond_to?(method_name)
            Itamae.logger.error "action #{action.inspect} is unavailable"
          end
        else
          Itamae.logger.with_indent { send(method_name) }
        end

        # if different?
        #   updated!
        #   runner.handler.event(:attribute_changed, from: @current_attributes, to: @attributes)
        # end
      end
    end
  end
end
