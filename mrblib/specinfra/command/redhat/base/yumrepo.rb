class Specinfra::Command::Redhat::Base::Yumrepo < Specinfra::Command::Linux::Base::Yumrepo
  class << self
    def check_exists(repository)
      "yum repolist all -C | grep -qsE \"^[\\!\\*]?#{escape(repository)}\(\\s\|$\|\\/)\""
    end

    def check_is_enabled(repository)
      "yum repolist enabled -C | grep -qs \"^[\\!\\*]\\?#{escape(repository)}\""
    end
  end
end


