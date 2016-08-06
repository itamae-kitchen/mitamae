class Specinfra::Command::Darwin::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'false'
    end

    def get_cpu
      'false'
    end

    def get_hostname
      'hostname -s'
    end

    def get_domain
      'hostname -f | ' +
      'awk -v h=`hostname -s` \'$1 ~ h { sub(h".", "", $1); print $1 }\''
    end

    def get_fqdn
      'hostname -f'
    end

    def get_filesystem
      'df -k'
    end
  end
end
