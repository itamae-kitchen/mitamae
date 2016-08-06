module Specinfra
  module Command
    module Module
      module Zfs
        def check_exists(zfs)
            "zfs list -H #{escape(zfs)}"
        end

        def check_has_property(zfs, property=nil)
          commands = []
          property.sort.each do |key, value|
            regexp = "^#{value}$"
            commands << "zfs list -H -o #{escape(key)} #{escape(zfs)} | grep -- #{escape(regexp)}"
          end
          commands.join(' && ')
        end

        def get_property(zfs)
          "zfs get -Hp -o property,value all #{escape(zfs)}"
        end
      end
    end
  end
end

