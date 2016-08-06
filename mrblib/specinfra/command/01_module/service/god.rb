module Specinfra
  module Command
    module Module
      module Service
        module God
          def check_is_monitored_by_god(service)
            "god status #{escape(service)}"
          end
        end
      end
    end
  end
end
