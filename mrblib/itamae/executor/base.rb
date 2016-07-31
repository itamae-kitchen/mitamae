module Itamae
  module Executor
    class Base
      def initialize(resource, options)
        @resource = resource
        @backend  = Backend.new(shell: options[:shell])
        @dry_run  = options[:dry_run]
      end

      def execute
        # check if
        [@resource.attributes[:action]].flatten.each do |action|
          run_action(action)
        end
        # XXX: verify (`verify` method in resource)
        # if updated?
        #   runner.diff_found!
        #   # XXX: notify (`notifies` and `subscribes` in resource)
        # end
      end

      def action_nothing
        # noop
      end

      private

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

          # if different?
          #   updated!
          # end
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

      # Shorthand to be used in subclass
      def run_command(*args)
        @backend.run_command(*args)
      end
    end
  end
end
