module Itamae
  class CommandResult
    attr_reader :stdout, :stderr, :exit_status

    def initialize(args = {})
      @stdout = args[:stdout] || ''
      @stderr = args[:stderr] || ''
      @exit_status = args[:exit_status] || 0
    end

    def success?
      @exit_status == 0
    end

    def failure?
      @exit_status != 0
    end
  end
end
