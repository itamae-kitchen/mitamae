# This class has API-limited version of MItamae::Backend to execute resource
module MItamae
  class Runner
    def initialize(options)
      @backend = options.fetch(:backend)
      @dry_run = options.fetch(:dry_run)
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
  end
end
