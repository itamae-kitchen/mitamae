class Specinfra::Command::Debian::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      # Until everything uses Upstart, this needs an OR.
      "ls /etc/rc#{level}.d/ | grep -- '^S..#{escape(service)}$' || grep '^\s*start on' /etc/init/#{escape(service)}.conf"
    end

    def enable(service)
      "update-rc.d #{escape(service)} defaults"
    end

    def disable(service)
      "update-rc.d -f #{escape(service)} remove"
    end

    def start(service)
      "service #{escape(service)} start"
    end

    def stop(service)
      "service #{escape(service)} stop"
    end

    def restart(service)
      "service #{escape(service)} restart"
    end

    def reload(service)
      "service #{escape(service)} reload"
    end
  end
end
