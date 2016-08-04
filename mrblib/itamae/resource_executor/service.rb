module Itamae
  module ResourceExecutor
    class Service < Base
      def initialize(*)
        super
        @under = attributes.provider ? "_under_#{attributes.provider}" : ""
      end

      def action_start
        unless @running
          run_specinfra(:"start_service#{@under}", attributes.name)
        end
      end

      def action_stop
        if @running
          run_specinfra(:"stop_service#{@under}", attributes.name)
        end
      end

      def action_restart
        run_specinfra(:"restart_service#{@under}", attributes.name)
      end

      def action_reload
        if @runinng
          run_specinfra(:"reload_service#{@under}", attributes.name)
        end
      end

      def action_enable
        unless @enabled
          run_specinfra(:"enable_service#{@under}", attributes.name)
        end
      end

      def action_disable
        if @enabled
          run_specinfra(:"disable_service#{@under}", attributes.name)
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :start, :restart, :stop, :reload
          current.running = run_specinfra(:"check_service_is_running#{@under}", attributes.name)
          @running = current.running
        when :enable, :disable
          current.enabled = run_specinfra(:"check_service_is_enabled#{@under}", attributes.name)
          @enabled = current.enabled
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :start, :restart
          desired.running = true
        when :stop
          desired.running = false
        when :enable
          desired.enabled = true
        when :disable
          desired.enabled = false
        end
      end
    end
  end
end
