module MItamae
  module ResourceExecutor
    class Service < Base
      def initialize(*)
        super
        @under = attributes.provider ? "_under_#{attributes.provider}" : ""
      end

      def apply
        if desired.has_key?(:running)
          if desired.running && !current.running
            run_specinfra(:"start_service#{@under}", attributes.name)
          elsif !desired.running && current.running
            run_specinfra(:"stop_service#{@under}", attributes.name)
          end
        end

        if desired.restarted
          run_specinfra(:"restart_service#{@under}", attributes.name)
        end

        if desired.reloaded && current.running
          run_specinfra(:"reload_service#{@under}", attributes.name)
        end

        if desired.has_key?(:enabled)
          if desired.enabled && !current.enabled
            run_specinfra(:"enable_service#{@under}", attributes.name)
          elsif !desired.enabled && current.enabled
            run_specinfra(:"disable_service#{@under}", attributes.name)
          end
        end
      end

      private

      def set_current_attributes(current, action)
        current.running = run_specinfra(:"check_service_is_running#{@under}", attributes.name)
        current.enabled = run_specinfra(:"check_service_is_enabled#{@under}", attributes.name)
        current.restarted = false
        current.reloaded = false
      end

      def set_desired_attributes(desired, action)
        case action
        when :start
          desired.running = true
        when :stop
          desired.running = false
        when :restart
          desired.restarted = true
        when :reload
          desired.reloaded = true
        when :enable
          desired.enabled = true
        when :disable
          desired.enabled = false
        end
      end
    end
  end
end
