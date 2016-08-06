class Specinfra::Command::Redhat::V5::Iptables < Specinfra::Command::Redhat::Base::Iptables
  class << self
    def check_has_rule(rule, table=nil, chain=nil)
      cmd =  "iptables-save"
      cmd += " -t #{escape(table)}" if table
      cmd += " | grep -- #{escape(rule)}"
      cmd
    end
  end
end
