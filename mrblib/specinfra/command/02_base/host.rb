class Specinfra::Command::Base::Host < Specinfra::Command::Base
  class << self
    def check_is_resolvable(name, type)
      if type == "dns"
        %Q[lookup=$(nslookup -timeout=1 #{escape(name)} | grep -A1 'Name:' | grep Address | awk -F': ' '{print $2}'); if [ "$lookup" ]; then $(exit 0); else $(exit 1); fi]
      elsif type == "hosts"
        "sed 's/#.*$//' /etc/hosts | grep -w -- #{escape(name)} /etc/hosts"
      else
        "getent hosts #{escape(name)}"
      end
    end

    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -w #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        "nc -w #{escape(timeout)} -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)}"
      end
    end

    # getent hosts on a dualstack machine will most likely 
    # return the ipv6 address to ensure one can more cleary
    # define the outcome the ipv{4,6}_address are used. 
    def get_ipaddress(name)
      "getent hosts #{escape(name)} | awk '{print $1}'"
    end
    def get_ipv4_address(name)
      # Will return multiple values pick the first and exit
      "getent ahostsv4 #{escape(name)} | awk '{print $1; exit}'"
    end
    def get_ipv6_address(name)
      # Will return multiple values pick the first and exit
      "getent ahostsv6 #{escape(name)} | awk '{print $1; exit}'"
    end
  end
end
