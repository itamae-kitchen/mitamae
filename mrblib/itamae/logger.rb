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

    CODE_BY_COLOR = {
      red:   31,
      green: 32,
      clear: nil,
    }

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
      @color = :clear
    end

    def debug?
      DEBUG >= @level
    end

    def error?
      ERROR >= @level
    end

    def info?
      INFO >= @level
    end

    def debug(message)
      if debug?
        add('DEBUG', message)
      end
    end

    def error(message)
      if error?
        add('ERROR', message)
      end
    end

    def info(message)
      if info?
        add('INFO', message)
      end
    end

    def with_indent
      @indent_level += 1
      yield
    ensure
      @indent_level -= 1
    end

    def with_indent_if(cond)
      if cond
        with_indent { yield }
      else
        yield
      end
    end

    def color(col)
      unless CODE_BY_COLOR.keys.include?(col)
        raise ArgumentError, "unexpected color: '#{col}'"
      end

      original, @color = @color, col
      yield
    ensure
      @color = original
    end

    private

    def add(level, message)
      message.split("\n").each do |line|
        puts colorize("#{"%5s" % level} : #{INDENT * @indent_level}#{line}")
      end
    end

    def colorize(str)
      code = CODE_BY_COLOR[@color]
      return str unless code

      "\033[%dm%s\033[0m" % [code, str]
    end
  end
end
