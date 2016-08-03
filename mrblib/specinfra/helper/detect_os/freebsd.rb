module Specinfra
  module Helper
    class DetectOs
      class Freebsd < Specinfra::Helper::DetectOs
        def detect
          if ( uname = run_command('uname -sr').stdout ) && uname =~ /FreeBSD/i
            if uname =~ /(\d+)\./
              { :family => 'freebsd', :release => $1 }
            else
              { :family => 'freebsd', :release => nil }
            end
          end
        end
      end
    end
  end
end
