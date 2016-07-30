module Itamae
  class << self
    attr_accessor :logger
  end

  class Logger
    DEBUG   = 0
    INFO    = 1
    WARN    = 2
    ERROR   = 3
    FATAL   = 4
    UNKNOWN = 5

    attr_reader :level

    def initialize(severity)
      case severity.to_s.downcase
      when 'debug'
        @level = DEBUG
      when 'info'
        @level = INFO
      when 'warn'
        @level = WARN
      when 'error'
        @level = ERROR
      when 'fatal'
        @level = FATAL
      when 'unknown'
        @level = UNKNOWN
      else
        raise ArgumentError, "invalid log level: #{severity}"
      end
    end

    def debug(message)
      add("DEBUG : #{message}")
    end

    def error(message)
      add("ERROR : #{message}")
    end

    def info(message)
      add(" INFO : #{message}")
    end

    private

    def add(message)
      puts message
    end
  end
end
