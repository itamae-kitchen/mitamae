# This class has API-limited version of MItamae::Backend to execute resource
module MItamae
  class Runner
    def initialize(backend:, inline_backend:, dry_run:)
      @backend = backend
      @inline_backend = inline_backend
      @dry_run = dry_run
    end

    def dry_run?
      @dry_run
    end

    def run_command(*args)
      @backend.run_command(*args)
    end

    def get_command(*args)
      @backend.get_command(*args)
    end

    def find_inline_backend(type, *args)
      @inline_backend.find_backend(type, *args)
    end
  end
end
