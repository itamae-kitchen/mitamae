module Specinfra
  module Helper
    class DetectOs
      class Nixos < Specinfra::Helper::DetectOs
        def detect
          if run_command('ls /var/run/current-system/sw').success?
            { :family => 'nixos', :release => nil }
          end
        end
      end
    end
  end
end
