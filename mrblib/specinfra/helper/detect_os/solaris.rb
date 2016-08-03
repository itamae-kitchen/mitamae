module Specinfra
  module Helper
    class DetectOs
      class Solaris < Specinfra::Helper::DetectOs
        def detect
          if ( uname = run_command('uname -sr').stdout) && uname =~ /SunOS/i
            if uname =~ /5.10/
              { family: 'solaris', release: 10 }
            elsif run_command('grep -q "Oracle Solaris 11" /etc/release').success?
              { family: 'solaris', release: 11 }
            elsif run_command('grep -q "OpenIndiana" /etc/release').success?
              { family: 'solaris', release: 11 }
            elsif run_command('grep -q SmartOS /etc/release').success?
              { family: 'smartos', release: nil }
            else
              { family: 'solaris', release: nil }
            end
          end
        end
      end
    end
  end
end
