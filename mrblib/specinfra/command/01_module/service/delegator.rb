module Specinfra
  module Command
    module Module
      module Service
        module Delegator
          def def_delegator_service_under(under)
            self.send(:alias_method, :check_is_enabled, :"check_is_enabled_under_#{under}")
            self.send(:alias_method, :check_is_running, :"check_is_running_under_#{under}")
            self.send(:alias_method, :enable,           :"enable_under_#{under}")
            self.send(:alias_method, :disable,          :"disable_under_#{under}")
            self.send(:alias_method, :start,            :"start_under_#{under}")
            self.send(:alias_method, :stop,             :"stop_under_#{under}")
            self.send(:alias_method, :restart,          :"restart_under_#{under}")
            self.send(:alias_method, :reload,           :"reload_under_#{under}")
          end
        end
      end
    end
  end
end
