module Itamae
  class << self
    attr_accessor :logger
  end

  class Logger
    INDENT  = '  '

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
      @indent_level = 0
    end

    def debug(message)
      add('DEBUG', message)
    end

    def error(message)
      add('ERROR', message)
    end

    def info(message)
      add('INFO', message)
    end

    def with_indent
      @indent_level += 1
      yield
    ensure
      @indent_level -= 1
    end

    private

    def add(level, message)
      message.split("\n").each do |line|
        puts "#{"%5s" % level} : #{INDENT * @indent_level}#{line}"
      end
    end
  end
end
