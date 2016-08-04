module Specinfra
  module Command
    module Module
      module Service
        module Supervisor
          def check_is_running_under_supervisor(service)
            "supervisorctl status #{escape(service)} | grep RUNNING"
          end
        end
      end
    end
  end
end
