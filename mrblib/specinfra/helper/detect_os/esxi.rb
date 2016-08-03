module Specinfra
  module Helper
    class DetectOs
      class Esxi < Specinfra::Helper::DetectOs
        def detect
          if run_command('vmware -v').success?
            line = run_command('vmware -v').stdout
            if line =~ /VMware ESXi (.*)/
              { :family => 'esxi', :release => $1 }
            end
          end
        end
      end
    end
  end
end
