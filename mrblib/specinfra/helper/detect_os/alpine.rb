module Specinfra
  module Helper
    class DetectOs
      class Alpine < Specinfra::Helper::DetectOs
        def detect
          if run_command('ls /etc/alpine-release').success?
            release = run_command('cat /etc/alpine-release').stdout
            { family: 'alpine', release: release }
          end
        end
      end
    end
  end
end
