class Specinfra::Command::Gentoo::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      regexp = /\s*#{service}\s*\|\s*(boot|default)/
      "rc-update show | grep -- #{escape(regexp)}"
    end

    def check_is_running(service)
      "/etc/init.d/#{escape(service)} status"
    end
  end
end







