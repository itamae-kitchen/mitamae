module Specinfra
  module Command
    module Module
      module Service
        module Monit
          def check_is_monitored_by_monit(service)
            "monit status"
          end
        end
      end
    end
  end
end
