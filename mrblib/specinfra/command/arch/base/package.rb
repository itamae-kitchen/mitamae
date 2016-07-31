module Specinfra
  module Command
    class Arch
      class Base
        class Package < Specinfra::Command::Linux::Base::Package
          class << self
            def check_is_installed(package,version=nil)
              if version
                grep = version.include?('-') ? "^#{escape(version)}$" : "^#{escape(version)}-"
                "pacman -Q #{escape(package)} | awk '{print $2}' | grep '#{grep}'"
              else
                "pacman -Q #{escape(package)} || pacman -Qg #{escape(package)}"
              end
            end

            def get_version(package, opts=nil)
              "pacman -Qi #{package} | grep Version | awk '{print $3}'"
            end

            def install(package, version=nil, option='')
              # Pacman doesn't support to install specific version.
              "pacman -S --noconfirm #{option} #{package}"
            end

            # Should this method be here or not ?
            def sync_repos
              "pacman -Syy"
            end

            def remove(package, option='')
              "pacman -R --noconfirm #{option} #{package}"
            end
          end
        end
      end
    end
  end
end
