class Specinfra::Command::Base::Service < Specinfra::Command::Base
  class << self
    include Specinfra::Command::Module::Service::Init
    include Specinfra::Command::Module::Service::Systemd
    include Specinfra::Command::Module::Service::Daemontools
    include Specinfra::Command::Module::Service::Supervisor
    include Specinfra::Command::Module::Service::Upstart
    include Specinfra::Command::Module::Service::Runit
    include Specinfra::Command::Module::Service::Monit
    include Specinfra::Command::Module::Service::God
    extend  Specinfra::Command::Module::Service::Delegator

    def_delegator_service_under :init
  end
end
