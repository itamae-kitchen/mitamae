module Itamae
  module ResourceExecutor
    class Execute < Base
      def action_run
        run_command(@resource.attributes.command)
        updated!
      end

      private

      def set_current_attributes(current, action)
        case action
        when :run
          current.executed = false
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :run
          desired.executed = true
        end
      end
    end
  end
end
