module MItamae
  module ResourceExecutor
    class LocalRubyBlock < Base
      def apply
        if desired.executed
          if desired.cwd
            Dir.chdir(desired.cwd) do
              desired.block.call
            end
          else
            desired.block.call
          end
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
