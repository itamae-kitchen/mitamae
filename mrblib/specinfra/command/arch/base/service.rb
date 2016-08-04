module Specinfra
  module Command
    class Arch
      class Base
        class Service < Specinfra::Command::Linux::Base::Service
          class << self
            include Specinfra::Command::Module::Systemd
          end
        end
      end
    end
  end
end
