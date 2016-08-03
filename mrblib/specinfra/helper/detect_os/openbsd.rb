module Specinfra
  module Helper
    class DetectOs
      class Openbsd < Specinfra::Helper::DetectOs
        def detect
          if ( uname = run_command('uname -sr').stdout ) && uname =~ /OpenBSD/i
            if uname =~ /(\d+\.\d+)/
              { :family => 'openbsd', :release => $1 }
            else
              { :family => 'openbsd', :release => nil }
            end
          end
        end
      end
    end
  end
end
