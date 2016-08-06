class Specinfra::Command::Linux::Base::Ip6tables < Specinfra::Command::Base::Ip6tables
  class << self
    def check_has_rule(rule, table=nil, chain=nil)
      cmd = "ip6tables"
      cmd += " -t #{escape(table)}" if table
      cmd += " -S"
      cmd += " #{escape(chain)}" if chain
      cmd += " | grep -- #{escape(rule)}"
      cmd += " || ip6tables-save"
      cmd += " -t #{escape(table)}" if table
      cmd += " | grep -- #{escape(rule)}"
      cmd
    end
  end
end
