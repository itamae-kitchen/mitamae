class Specinfra::Command::Darwin::Base::Host < Specinfra::Command::Base::Host
  class << self
    def check_is_resolvable(name, type)
      if type == "dns"
        ## try to resolve either A or AAAA record; grep is used to return the appropriate exit code
        %Q{dig +search +short +time=1 -q #{escape(name)} a #{escape(name)} aaaa | grep -qie '^[0-9a-f:.]*$'}
      elsif type == "hosts"
        "sed 's/#.*$//' /etc/hosts | grep -w -- #{escape(name)}"
      else
        ## grep is required as dscacheutil always returns exit code 0
        "dscacheutil -q host -a name #{escape(name)} | grep -q '_address:'"
      end
    end

    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -t #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        "nc -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} -w #{escape(timeout)}"
      end
    end

    def get_ipaddress(name)
      # If the query returns multiple records the most likey match is returned.
      # Generally this means IPv6 wins over IPv4.
      %Q{dscacheutil -q host -a name #{escape(name)} | } + 
      %Q{awk '/^ipv6_/{ ip = $2 }; /^$/{ exit }; /^ip_/{ ip = $2; exit}; END{ print ip }'}
    end
    def get_ipv4_address(name)
      ## With dscacheutil multiple IPs can be returned for IPv4 just pick the first one
      %Q{dscacheutil -q host -a name #{escape(name)} | awk '/^ip_/{ print $2; exit }'}
    end
    def get_ipv6_address(name)
      ## With dscacheutil multiple IPs can be returned. For IPv6 the link-local is displayed first
      ## hence the last entry is picked.
      %Q{dscacheutil -q host -a name #{escape(name)} | awk '/^ipv6_/{ ip = $2 } END{ print ip }'}
    end
  end
end
