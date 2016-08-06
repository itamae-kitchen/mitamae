class Specinfra::Command::Linux::Base::Bridge < Specinfra::Command::Base::Bridge
  class << self
    def check_exists(name)
      "ip link show #{name}"
    end

    def check_has_interface(name, interface)
      "brctl show #{name} | grep -o #{interface}"
    end
  end
end
