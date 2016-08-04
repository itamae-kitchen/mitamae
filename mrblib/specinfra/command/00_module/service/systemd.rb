module Specinfra
  module Command
    module Module
      module Service
        module Systemd
          def check_is_enabled_under_systemd(service, level=nil)
            "systemctl --quiet is-enabled #{escape(service)}"
          end

          def check_is_running_under_systemd(service)
            "systemctl is-active #{escape(service)}"
          end

          def enable_under_systemd(service)
            "systemctl enable #{escape(service)}"
          end

          def disable_under_systemd(service)
            "systemctl disable #{escape(service)}"
          end

          def start_under_systemd(service)
            "systemctl start #{escape(service)}"
          end

          def stop_under_systemd(service)
            "systemctl stop #{escape(service)}"
          end

          def restart_under_systemd(service)
            "systemctl restart #{escape(service)}"
          end

          def reload_under_systemd(service)
            "systemctl reload #{escape(service)}"
          end
        end
      end
    end
  end
end
