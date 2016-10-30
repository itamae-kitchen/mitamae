class Specinfra::Command::Ubuntu::Base::Ppa < Specinfra::Command::Debian::Base::Ppa
  class << self
    def check_exists(package)
      %Q{find /etc/apt/ -name \*.list | xargs grep -o -E "deb +[\\"']?http://ppa.launchpad.net/#{to_apt_line_uri(package)}"}
    end

    def check_is_enabled(package)
      %Q{find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/#{to_apt_line_uri(package)}"}
    end

    private

    def to_apt_line_uri(repo)
      escape(repo.gsub(/^ppa:/,''))
    end
  end
end
