module Specinfra
  module Command
    module Module
      module Service
        module Daemontools
          def check_is_enabled_under_daemontools(service)
            "test -L #{service_dir}/#{escape(service)} && test -f #{service_dir}/#{escape(service)}/run"
          end

          def check_is_running_under_daemontools(service)
            "svstat #{service_dir}/#{escape(service)} | grep -E 'up \\(pid [0-9]+\\)'"
          end

          def enable_under_daemontools(service, directory)
            "ln -snf #{escape(directory)} #{service_dir}/#{escape(service)}"
          end

          def disable_under_daemontools(service)
            "( cd #{service_dir}/#{escape(service)} && rm -f #{service_dir}/#{escape(service)} && svc -dx . log )"
          end

          def start_under_daemontools(service)
            "svc -u #{service_dir}/#{escape(service)}"
          end

          def stop_under_daemontools(service)
            "svc -d #{service_dir}/#{escape(service)}"
          end

          def restart_under_daemontools(service)
            "svc -t #{service_dir}/#{escape(service)}"
          end

          def reload_under_daemontools(service)
            "svc -h #{service_dir}/#{escape(service)}"
          end

	  private
	  def service_dir
	    '$([ -d /service ] && echo /service || echo /etc/service)'
	  end
        end
      end
    end
  end
end
