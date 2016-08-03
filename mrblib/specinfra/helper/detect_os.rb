module Specinfra
  module Helper
    class DetectOs
      def self.all
        [
          Arch,
        ]
      end

      def initialize(backend)
        @backend = backend
      end

      def run_command(*args)
        @backend.run_command(*args)
      end
    end
  end
end
