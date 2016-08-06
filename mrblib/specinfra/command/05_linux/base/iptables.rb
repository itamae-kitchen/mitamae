class Specinfra::Command::Linux::Base::Iptables < Specinfra::Command::Base::Iptables
  class << self
    def check_has_rule(rule, table=nil, chain=nil)
      cmd = "iptables"
      cmd += " -t #{escape(table)}" if table
      cmd += " -S"
      cmd += " #{escape(chain)}" if chain
      cmd += " | grep -- #{escape(rule)}"
      cmd
    end
  end
end
