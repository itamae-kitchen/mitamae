class Specinfra::Command::Linux::Base::Interface < Specinfra::Command::Base::Interface
  class << self
    def check_exists(name)
      "ip link show #{name}"
    end

    def get_speed_of(name)
      "cat /sys/class/net/#{name}/speed"
    end

    def get_mtu_of(name)
      "cat /sys/class/net/#{name}/mtu"
    end

    def check_has_ipv4_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        ip_address << " "
      else
        ip_address << "/"
      end
      ip_address.gsub!(".", "\\.")
      "ip -4 addr show #{interface} | grep 'inet #{ip_address}'"
    end

    def check_has_ipv6_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        ip_address << " "
      else
        ip_address << "/"
      end
      ip_address.downcase!
      "ip -6 addr show #{interface} | grep 'inet6 #{ip_address}'"
    end

    def get_ipv4_address(interface)
      "ip -4 addr show #{interface} | grep #{interface}$ | awk '{print $2}'"
    end

    def get_ipv6_address(interface)
      "ip -6 addr show #{interface} | grep inet6 | awk '{print $2}'"
    end

    def get_link_state(name)
      "cat /sys/class/net/#{name}/operstate"
    end
  end
end
