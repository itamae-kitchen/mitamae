module Specinfra
  module Helper
    class DetectOs
      class Aix < Specinfra::Helper::DetectOs
        def detect
          if run_command('uname -s').stdout =~ /AIX/i
            line = run_command('uname -rvp').stdout
            if line =~ /(\d+)\s+(\d+)\s+(.*)/
              { family: 'aix', release: "#{$2}.#{$1}", arch: $3 }
            else
              { family: 'aix', release: nil, arch: nil }
            end
          end
        end
      end
    end
  end
end
