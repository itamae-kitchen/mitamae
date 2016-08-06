class Specinfra::Command::Debian::V8::Service < Specinfra::Command::Debian::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd

    def check_is_enabled_under_systemd(service, level=nil)
      [
        super(service),
        "ls /etc/rc[S5].d/S??#{escape(service)} >/dev/null 2>/dev/null"
      ].join('||')
    end

    alias_method :check_is_enabled, :check_is_enabled_under_systemd
  end
end
