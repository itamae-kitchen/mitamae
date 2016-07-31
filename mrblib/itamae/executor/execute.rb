module Itamae
  module Executor
    class Execute < Base
      def action_run
        run_command(@resource.attributes.command)
        updated!
      end

      private

      def set_current_attributes(attributes, action)
        case action
        when :run
          attributes.executed = false
        end
      end

      def set_desired_attributes(attributes, action)
        case action
        when :run
          attributes.executed = true
        end
      end
    end
  end
end
