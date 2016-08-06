class Specinfra::Command::Linux::Base::File < Specinfra::Command::Base::File
  class << self
    def check_is_accessible_by_user(file, user, access)
      "su -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
    end

    def check_is_immutable(file)
      check_attribute(file, 'i')
    end

    def check_attribute(file, attribute)
      "lsattr -d #{escape(file)} 2>&1 | " + 
      "awk '$1~/^[A-Za-z-]+$/ && $1~/#{escape(attribute)}/ {exit 0} {exit 1}'"
    end

    def get_selinuxlabel(file)
      "stat -c %C #{escape(file)}"
    end
  end
end
