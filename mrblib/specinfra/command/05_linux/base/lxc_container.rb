class Specinfra::Command::Linux::Base::LxcContainer < Specinfra::Command::Base::LxcContainer
  class << self
    def check_exists(container)
      "lxc-ls -1 | grep -w #{escape(container)}"
    end

    def check_is_running(container)
      "lxc-info -n #{escape(container)} -s | grep -w RUNNING"
    end
  end
end
