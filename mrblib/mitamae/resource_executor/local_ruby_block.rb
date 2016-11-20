module MItamae
  module ResourceExecutor
    class LocalRubyBlock < Base
      def apply(_, desired)
        desired.block.call
      end

      private

      def set_current_attributes(*)
        # noop
      end

      def set_desired_attributes(*)
        # noop
      end
    end
  end
end
