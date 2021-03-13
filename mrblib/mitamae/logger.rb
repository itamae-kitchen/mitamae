module MItamae
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

    attr_reader :level, :enable_color

    def initialize(severity, enable_color)
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
      @enable_color = enable_color
    end

    def debug?
      DEBUG >= @level
    end

    def info?
      INFO >= @level
    end

    def warn?
      WARN >= @level
    end

    def error?
      ERROR >= @level
    end

    def fatal?
      FATAL >= @level
    end

    def debug(message)
      if debug?
        add(:debug, message)
      end
    end

    def info(message)
      if info?
        add(:info, message)
      end
    end

    def warn(message)
      if warn?
        add(:warn, message)
      end
    end

    def error(message)
      if error?
        add(:error, message)
      end
    end

    def fatal(message)
      if fatal?
        add(:fatal, message)
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

    def add(severity, message)
      message.split("\n").each do |line|
        puts colorize(severity, "#{"%5s" % severity.to_s.upcase} : #{INDENT * @indent_level}#{line}")
      end
    end

    def colorize(severity, str)
      return str unless @enable_color
      color =
        case severity
        when :error
          :red
        else
          @color
        end
      code = CODE_BY_COLOR[color]
      return str unless code

      "\033[%dm%s\033[0m" % [code, str]
    end
  end
end
