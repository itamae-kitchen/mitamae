module Specinfra
  module Command
    module Module
      module Service
        module Init
          def check_is_enabled_under_init(service, level=3)
            "chkconfig --list #{escape(service)} | grep #{level}:on"
          end

          def check_is_running_under_init(service)
            "service #{escape(service)} status"
          end

          def enable_under_init(service)
            "chkconfig #{escape(service)} on"
          end

          def disable_under_init(service)
            "chkconfig #{escape(service)} off"
          end

          def start_under_init(service)
            "service #{escape(service)} start"
          end

          def stop_under_init(service)
            "service #{escape(service)} stop"
          end

          def restart_under_init(service)
            "service #{escape(service)} restart"
          end

          def reload_under_init(service)
            "service #{escape(service)} reload"
          end
        end
      end
    end
  end
end

