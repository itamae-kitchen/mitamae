class Specinfra::Command::Linux::Base::SelinuxModule < Specinfra::Command::Base::SelinuxModule
  class << self
    def check_is_installed(name, version=nil)
      cmd =  "semodule -l | grep $'^#{escape(name)}\\t"
      cmd += "#{escape(version)}\\t" unless version.nil?
      cmd += "'"
      cmd
    end

    def check_is_enabled(name)
      cmd =  "semodule -l | grep $'^#{escape(name)}\\t'"
      cmd += " | grep -v $'^#{escape(name)}\\t.*\\tDisabled$'"
      cmd
    end
  end
end
