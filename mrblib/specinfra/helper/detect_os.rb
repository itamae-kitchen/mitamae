module Specinfra
  module Helper
    class DetectOs
      def self.all
        [
          Aix,
          Alpine,
          Arch,
          Coreos,
          Darwin,
          Debian,
          Esxi,
          Freebsd,
          Gentoo,
          Nixos,
          Openbsd,
          Plamo,
          Poky,
          Redhat,
          Solaris,
          Suse,
        ]
      end

      def initialize(backend)
        @backend = backend
      end

      def run_command(cmd)
        @backend.run_command(cmd, error: false)
      end
    end
  end
end
