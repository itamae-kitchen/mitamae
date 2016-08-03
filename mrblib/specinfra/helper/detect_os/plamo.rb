module Specinfra
  module Helper
    class DetectOs
      class Plamo < Specinfra::Helper::DetectOs
        def detect
          if run_command('ls /usr/lib/setup/Plamo-*').success?
            { family: 'plamo', release: nil }
          end
        end
      end
    end
  end
end
