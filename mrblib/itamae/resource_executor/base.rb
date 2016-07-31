module Itamae
  module ResourceExecutor
    class Base
      def initialize(resource, options)
        @resource = resource
        @backend  = options[:backend]
        @dry_run  = options[:dry_run]
        @updated  = false
      end

      def execute
        Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}]"

        Itamae.logger.with_indent_if(Itamae.logger.debug?) do
          return if skip_condition?

          [@resource.attributes[:action]].flatten.each do |action|
            run_action(action)
          end

          # XXX: verify (`verify` method in resource)
          # if updated?
          #   # XXX: notify (`notifies` and `subscribes` in resource)
          # end
        end
      rescue Backend::CommandExecutionError
        Itamae.logger.error "#{@resource.resource_type}[#{@resource.resource_name}] Failed."
        exit 2
      end

      def action_nothing
        # noop
      end

      private

      def skip_condition?
        if @resource.only_if_command && run_command(@resource.only_if_command, error: false).exit_status != 0
          Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] Execution skipped because of only_if attribute"
          true
        elsif @resource.not_if_command && run_command(@resource.not_if_command, error: false).exit_status == 0
          Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] Execution skipped because of not_if attribute"
          true
        else
          false
        end
      end

      def run_action(action)
        Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] action: #{action}"

        Itamae.logger.with_indent_if(Itamae.logger.debug?) do
          # The (in *) logging is just for backward compatibility with original Itamae.
          Itamae.logger.debug '(in pre_action)'
          next_attributes = desired_attributes(action)

          Itamae.logger.debug '(in set_current_attributes)'
          prev_attributes = current_attributes(action)

          Itamae.logger.debug '(in show_differences)'
          show_differences(prev_attributes, next_attributes)

          method_name = "action_#{action}"
          if @dry_run
            unless respond_to?(method_name)
              Itamae.logger.error "action #{action.inspect} is unavailable"
            end
          else
            send(method_name)
          end

          if different?(action, prev_attributes)
            updated!
          end
        end
      end

      def different?(action, prev_attributes)
        current_attributes(action).any? do |key, current_value|
          !current_value.nil? && !prev_attributes[key].nil? && current_value != prev_attributes[key]
        end
      end

      def show_differences(prev_attributes, next_attributes)
        prev_attributes.each_pair do |key, prev_value|
          next_value = next_attributes[key]
          if prev_value.nil? && next_value.nil?
            # ignore
          elsif prev_value.nil? && !next_value.nil?
            Itamae.logger.color :green do
              Itamae.logger.info "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will be '#{next_value}'"
            end
          elsif prev_value == next_value || next_value.nil?
            Itamae.logger.debug "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will not change (current value is '#{prev_value}')"
          else
            Itamae.logger.color :green do
              Itamae.logger.info "#{@resource.resource_type}[#{@resource.resource_name}] #{key} will change from '#{prev_value}' to '#{next_value}'"
            end
          end
        end
      end

      # The real status of attributes described in resource and ones which can't be checked
      # (i.e. executed = false of execute resource), whose keys should be based on action.
      def current_attributes(action)
        Hashie::Mash.new.tap do |attributes|
          set_current_attributes(attributes, action)
        end
      end

      def set_current_attributes(attributes, action)
        raise NotImplementedError
      end

      # Attributes described in resource and ones which is desired and can't be checked
      # (i.e. executed = true of execute resource), whose keys should be based on action.
      def desired_attributes(action)
        Hashie::Mash.new.tap do |attributes|
          set_desired_attributes(attributes, action)
        end
      end

      def set_desired_attributes(attributes, action)
        raise NotImplementedError
      end

      def run_command(*args)
        args << {} unless args.last.is_a?(Hash)

        args.last[:user] ||= @resource.attributes.user
        args.last[:cwd]  ||= @resource.attributes.cwd
        @backend.run_command(*args)
      end

      def updated?
        @updated
      end

      def updated!
        Itamae.logger.debug "This resource is updated."
        @updated = true
      end
    end
  end
end
