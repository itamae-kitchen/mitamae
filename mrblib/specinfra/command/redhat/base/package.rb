class Specinfra::Command::Redhat::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(package)}-#{escape(version)}"
      end
      cmd
    end

    alias :check_is_installed_by_rpm :check_is_installed

    def get_version(package, opts=nil)
      "rpm -q --qf '%{VERSION}-%{RELEASE}' #{package}"
    end

    def install(package, version=nil, option='')
      if version
        full_package = "#{package}-#{version}"
      else
        full_package = package
      end
      cmd = "yum -y #{option} install #{full_package}"
    end

    def remove(package, option='')
      "yum -y #{option} remove #{package}"
    end
  end
end









