class Specinfra::Command::Redhat::V7::Host < Specinfra::Command::Redhat::Base::Host
  class << self
    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -w #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        # RHEL7 comes with ncat which does no longer sport the -z option
        # hence this kludge
        "ncat -vvvv#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} " +
        "-w #{escape(timeout)} -i #{escape(timeout)} 2>&1 | " +
        "grep -q SUCCESS"
      end
    end
  end
end
