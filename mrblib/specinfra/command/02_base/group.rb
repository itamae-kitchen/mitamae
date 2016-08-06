class Specinfra::Command::Base::Group < Specinfra::Command::Base
  class << self
    def check_exists(group)
      "getent group #{escape(group)}"
    end

    def check_has_gid(group, gid)
      "getent group #{escape(group)} | cut -f 3 -d ':' | grep -w -- #{escape(gid)}"
    end

    def get_gid(group)
      "getent group #{escape(group)} | cut -f 3 -d ':'"
    end

    def update_gid(group, gid)
      "groupmod -g #{escape(gid)} #{escape(group)}"
    end

    def add(group, options)
      command = ['groupadd']
      command << '-g' << escape(options[:gid])  if options[:gid]
      command << escape(group)
      command.join(' ')
    end
  end
end
