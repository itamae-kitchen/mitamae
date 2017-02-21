module MItamae
  module ResourceExecutor
    class LocalRubyBlock < Base
      def apply
        if desired.executed
          desired.block.call
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
