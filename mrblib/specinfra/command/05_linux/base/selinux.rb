class Specinfra::Command::Linux::Base::Selinux < Specinfra::Command::Base::Selinux
  class << self
    def check_has_mode(mode, policy = nil)
      cmd =  ""
      cmd += "test ! -f /etc/selinux/config || (" if mode == "disabled"
      cmd += "getenforce | grep -i -- #{escape(mode)}"
      cmd += %Q{ && grep -iE -- '^\\s*SELINUX=#{escape(mode)}\\>' /etc/selinux/config}
      cmd += %Q{ && grep -iE -- '^\\s*SELINUXTYPE=#{escape(policy)}\\>' /etc/selinux/config} if policy != nil
      cmd += ")" if mode == "disabled"
      cmd
    end
  end
end
