module Specinfra
  module Helper
    class DetectOs
      class Darwin < Specinfra::Helper::DetectOs
        def detect
          if (uname = run_command('uname -sr').stdout) && uname =~ /Darwin/i
            if uname =~ /([\d.]+)$/
               { family: 'darwin', release: $1 }
            else
               { family: 'darwin', release: nil }
            end
          end
        end
      end
    end
  end
end
