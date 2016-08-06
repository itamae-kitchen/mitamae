class Specinfra::Command::Darwin::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "launchctl list | grep #{escape(service)}"
    end

    def check_is_running(service)
      "launchctl list | grep #{escape(service)} | grep -E '^[0-9]+'"
    end
  end
end
