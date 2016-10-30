module MItamae
  class CommandResult
    attr_reader :exit_status

    def initialize(args = {})
      @stdout_buf = args[:stdout] || ''
      @stderr_buf = args[:stderr] || ''
      @exit_status = args[:exit_status] || 0
    end

    def success?
      @exit_status == 0
    end

    def failure?
      @exit_status != 0
    end

    # Calling methods like `strip` directly to stdout buffer leads SIGPIPE.
    # Maybe we should handle this in open3. But for now, lazily do `dup` for performance.
    def stdout
      @stdout ||= @stdout_buf.dup
    end

    def stderr
      @stderr ||= @stderr_buf.dup
    end
  end
end
