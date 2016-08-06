class Specinfra::Command::Darwin::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      escaped_package = escape(File.basename(package))
      if version
        cmd = %Q[brew info #{escaped_package} | grep -E "^$(brew --prefix)/Cellar/#{escaped_package}/#{escape(version)}"]
      else
        cmd = "#{brew_list} | grep -E '^#{escaped_package}$'"
      end
      cmd
    end

    alias :check_is_installed_by_homebrew :check_is_installed

    def check_is_installed_by_homebrew_cask(package, version=nil)
      escaped_package = escape(File.basename(package))
      if version
        cmd = "brew cask info #{escaped_package} | grep -E '^/opt/homebrew-cask/Caskroom/#{escaped_package}/#{escape(version)}'"
      else
        cmd = "#{brew_cask_list} | grep -E '^#{escaped_package}$'"
      end
      cmd
    end

    def check_is_installed_by_pkgutil(package, version=nil)
      cmd = "pkgutil --pkg-info #{package}"
      cmd = "#{cmd} | grep '^version: #{escape(version)}'" if version
      cmd
    end

    def install(package, version=nil, option='')
      # Homebrew doesn't support to install specific version.
      cmd = "brew install #{option} '#{package}'"
    end

    def remove(package, option='')
      cmd = "brew uninstall #{option} '#{package}'"
    end

    def get_version(package, opts=nil)
      %Q[ls -1 "$(brew --prefix)/Cellar/#{package}/" | tail -1]
    end

    def brew_list
      # Since `brew list` is slow, directly check Cellar directory
      'ls -1 "$(brew --prefix)/Cellar/"'
    end

    def brew_cask_list
      # Since `brew cask list` is slow, directly check Caskroom directory
      # Brew cask can install in multiple directories
      "ls -1 /opt/homebrew-cask/Caskroom/ /usr/local/Caskroom"
    end
  end
end

