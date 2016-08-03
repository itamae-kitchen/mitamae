module Specinfra
  module Helper
    class DetectOs
      class Debian < Specinfra::Helper::DetectOs
        def detect
          if run_command('ls /etc/debian_version').success?
            distro  = nil
            release = nil
            lsb_release = run_command("lsb_release -ir")
            if lsb_release.success?
              lsb_release.stdout.each_line do |line|
                distro  = line.split(':').last.strip if line =~ /^Distributor ID:/
                release = line.split(':').last.strip if line =~ /^Release:/
              end
            else
              lsb_release = run_command("cat /etc/lsb-release")
              if lsb_release.success?
                lsb_release.stdout.each_line do |line|
                  distro  = line.split('=').last.strip if line =~ /^DISTRIB_ID=/
                  release = line.split('=').last.strip if line =~ /^DISTRIB_RELEASE=/
                end
              end
            end
            distro ||= 'debian'
            release ||= nil
            { family: distro.gsub(/[^[:alnum:]]/, '').downcase, release: release }
          end
        end
      end
    end
  end
end
