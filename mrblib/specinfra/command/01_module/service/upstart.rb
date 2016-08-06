module Specinfra
  module Command
    module Module
      module Service
        module Upstart
          def check_is_running_under_upstart(service)
            "initctl status #{escape(service)} | grep running"
          end
        end
      end
    end
  end
end
