module Specinfra
  module Helper
    class DetectOs
      class Poky < Specinfra::Helper::DetectOs
        def detect
          if ( uname = run_command('uname -r').stdout ) && uname =~ /poky/i
            { family: 'poky', release: run_command('cat /etc/version').stdout }
          end
        end
      end
    end
  end
end
