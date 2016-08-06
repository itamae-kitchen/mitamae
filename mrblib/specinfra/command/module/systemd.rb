module Specinfra
  module Command
    module Module
      module Systemd
        include Specinfra::Command::Module::Service::Systemd
        extend  Specinfra::Command::Module::Service::Delegator
        def_delegator_service_under :systemd
      end
    end
  end
end

