class Specinfra::Command::Redhat::V7::Service < Specinfra::Command::Redhat::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end
