class Specinfra::Command::Ubuntu::Base::Service < Specinfra::Command::Debian::Base::Service
  class << self
    def check_is_running(service)
      "service #{escape(service)} status && service #{escape(service)} status | egrep 'running|online'"
    end

    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 15
        self
      else
        Specinfra::Command::Ubuntu::V15::Service
      end
    end
  end
end
