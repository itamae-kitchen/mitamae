module MItamae
  module ResourceExecutor
    class Base
      def initialize(resource, runner)
        @resource = resource
        @runner   = runner
        @updated  = false
      end

      def execute(specific_action = nil)
        MItamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}]"

        MItamae.logger.with_indent_if(MItamae.logger.debug?) do
          return if skip_condition?

          [specific_action || @resource.attributes[:action]].flatten.each do |action|
            run_action(action)
          end

          verify
          if updated?
            notify
          end
        end
      rescue Backend::CommandExecutionError
        MItamae.logger.error "#{@resource.resource_type}[#{@resource.resource_name}] Failed."
        exit 2
      end

      # Given current and desired attributes, apply it to the real state.
      def apply
        raise NotImplementedError
      end

      private

      # @attribute [Hashie::Mash] current - Current state of attributes
      attr_reader :current

      # @attribute [Hashie::Mash] desired - Desired state of attributes
      attr_reader :desired

      def skip_condition?
        if @resource.only_if_command && run_command(@resource.only_if_command, error: false).exit_status != 0
          MItamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] Execution skipped because of only_if attribute"
          true
        elsif @resource.not_if_command && run_command(@resource.not_if_command, error: false).exit_status == 0
          MItamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] Execution skipped because of not_if attribute"
          true
        else
          false
        end
      end

      def run_action(action)
        MItamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] action: #{action}"

        MItamae.logger.with_indent_if(MItamae.logger.debug?) do
          MItamae.logger.debug '(in set_desired_attributes)'
          @desired = desired_attributes(action).freeze

          MItamae.logger.debug '(in set_current_attributes)'
          @current = current_attributes(action).freeze

          MItamae.logger.debug '(in pre_action)'
          pre_action

          MItamae.logger.debug '(in show_differences)'
          show_differences

          return if action == :nothing
          unless available_action?(action)
            MItamae.logger.error "action #{action.inspect} is unavailable"
            exit 1
          end
          return if @runner.dry_run?

          apply
          if different?
            updated!
          end
        end
      end

      def available_action?(action)
        @resource.class.available_actions.include?(action)
      end

      def different?
        current.any? do |key, current_value|
          !current_value.nil? &&
            !desired[key].nil? &&
            current_value != desired[key]
        end
      end

      def show_differences
        current.each_pair do |key, current_value|
          desired_value = desired[key]
          if current_value.nil? && desired_value.nil?
            # ignore
          elsif current_value.nil? && !desired_value.nil?
            MItamae.logger.color :green do
              MItamae.logger.info "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will be '#{desired_value}'"
            end
          elsif current_value == desired_value || desired_value.nil?
            MItamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will not change (current value is '#{current_value}')"
          else
            MItamae.logger.color :green do
              MItamae.logger.info "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will change from '#{current_value}' to '#{desired_value}'"
            end
          end
        end
      end

      def attributes
        @resource.attributes
      end

      # The real status of attributes described in resource and ones which can't be checked
      # (i.e. executed = false of execute resource), whose keys should be based on action.
      def current_attributes(action)
        Hashie::Mash.new.tap do |current|
          set_current_attributes(current, action)
        end
      end

      def set_current_attributes(current, action)
        raise NotImplementedError
      end

      # Attributes described in resource and ones which is desired and can't be checked
      # (i.e. executed = true of execute resource), whose keys should be based on action.
      def desired_attributes(action)
        Hashie::Mash.new(attributes).tap do |desired|
          set_desired_attributes(desired, action)
        end
      end

      def set_desired_attributes(desired, action)
        raise NotImplementedError
      end

      # All destructive operations before `show_differences` should be put here,
      # not in `set_desired_attributes` or `set_current_attributes`.
      def pre_action
        # Override this if necessary.
      end

      def run_command(*args)
        args << {} unless args.last.is_a?(Hash)

        args.last[:user] ||= attributes.user
        args.last[:cwd]  ||= attributes.cwd
        @runner.run_command(*args)
      end

      def check_command(*args)
        args << {} unless args.last.is_a?(Hash)

        args.last[:error] = false
        run_command(*args).exit_status == 0
      end

      def run_specinfra(type, *args)
        command = @runner.get_command(type, *args)

        if type.to_s.start_with?('check_')
          check_command(command)
        else
          run_command(command)
        end
      end

      def updated!
        MItamae.logger.debug "This resource is updated."
        @updated = true
      end

      def updated?
        @updated
      end

      def notify
        (@resource.notifications + @resource.recipe.root.subscriptions_for(@resource)).each do |notification|
          message = "Notifying #{notification.action} to #{notification.resource.resource_type} resource '#{notification.resource.resource_name}'"

          if notification.delayed?
            message << " (delayed)"
          elsif notification.immediately?
            message << " (immediately)"
          end

          MItamae.logger.info message

          if notification.instance_of?(Subscription)
            MItamae.logger.info "(because it subscribes this resource)"
          end

          if notification.delayed?
            @resource.recipe.delayed_notifications << notification
          elsif notification.immediately?
            ResourceExecutor.create(notification.action_resource, @runner).execute(notification.action)
          end
        end
      end

      def verify
        return if @resource.verify_commands.empty?
        MItamae.logger.info "Verifying..."
        MItamae.logger.with_indent do
          @resource.verify_commands.each do |command|
            run_command(command)
          end
        end
      end
    end
  end
end
