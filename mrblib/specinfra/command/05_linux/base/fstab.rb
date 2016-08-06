class Specinfra::Command::Linux::Base::Fstab < Specinfra::Command::Base::Fstab
  class << self
    def check_has_entry(mount_point)
      %Q(awk '{if($2=="#{escape(mount_point)}")print}' /etc/fstab | grep -v '^[[:space:]]*#')
    end

    alias :get_entry :check_has_entry
  end
end
