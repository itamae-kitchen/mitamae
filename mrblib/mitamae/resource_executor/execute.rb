module MItamae
  module ResourceExecutor
    class Execute < Base
      def apply
        if desired.executed
          run_command(desired.command)
          updated!
        end
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
