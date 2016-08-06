class Specinfra::Command::Darwin::Base::File < Specinfra::Command::Base::File
  class << self
    def check_is_accessible_by_user(file, user, access)
      "sudo -u #{user} -s /bin/test -#{access} #{file}"
    end

    def get_md5sum(file)
      "openssl md5 #{escape(file)} | cut -d'=' -f2 | cut -c 2-"
    end

    def get_sha256sum(file)
      "ruby -e \"require 'digest'; puts Digest::SHA256.hexdigest File.read '#{escape(file)}'\""
    end

    def check_is_linked_to(link, target)
      "stat -f %Y #{escape(link)} | grep -- #{escape(target)}"
    end

    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "stat -f %Su #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "stat -f %Sg #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def get_mode(file)
      "stat -f%Lp #{escape(file)}"
    end

    def get_owner_user(file)
      "stat -f %Su #{escape(file)}"
    end

    def get_owner_group(file)
      "stat -f %Sg #{escape(file)}"
    end
  end
end

