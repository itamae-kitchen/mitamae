class Specinfra::Command::Linux::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'cat /proc/meminfo'
    end

    def get_cpu
      'cat /proc/cpuinfo'
    end

    def get_hostname
      'hostname -s'
    end

    def get_domain
      'dnsdomainname'
    end

    def get_fqdn
      'hostname -f'
    end

    def get_filesystem
      'df -P'
    end

    def get_kernel
      'uname -s -r'
    end

    def get_block_device
      block_device_dirs = '/sys/block/*/{size,removable,device/{model,rev,state,timeout,vendor},queue/rotational}'
      "for f in $(ls #{block_device_dirs}); do echo -e \"${f}\t$(cat ${f})\"; done"
    end

    def get_system_product_name
      "dmidecode -s system-product-name"
    end 

  end
end
