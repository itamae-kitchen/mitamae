class Specinfra::Command::Base::Package < Specinfra::Command::Base
  class << self
    def check_is_installed_by_gem(name, version=nil)
      gem_installed_command("gem", name, version)
    end

    def check_is_installed_by_td_agent_gem(name, version=nil)
      gem_installed_command("/usr/sbin/td-agent-gem", name, version)
    end

    def check_is_installed_by_rvm(name, version=nil)
      regexp = "^#{name}"
      cmd = "rvm list strings | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    def check_is_installed_by_npm(name, version=nil)
      cmd = "npm ls #{escape(name)} -g"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    def check_is_installed_by_pecl(name, version=nil)
      regexp = "^#{name}"
      cmd = "pecl list | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    def check_is_installed_by_pear(name, version=nil)
      regexp = "^#{name}"
      cmd = "pear list -a | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    def check_is_installed_by_pip(name, version=nil)
      regexp = "^#{name} "
      cmd = "pip list | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    def check_is_installed_by_cpan(name, version=nil)
      regexp = "^#{name}"
      cmd = "cpan -l | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end

    private

    def gem_installed_command(gem_binary, name, version=nil)
      regexp = "^#{name} "
      cmd = "#{gem_binary} list --local | grep -iw -- #{escape(regexp)}"
      cmd = %Q!#{cmd} | grep -w -- "[( ]#{escape(version)}[,)]"! if version
      cmd
    end
  end
end
