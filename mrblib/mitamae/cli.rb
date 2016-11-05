module MItamae
  class CLI
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @args    = argv[1..-1]
      @command = @args.shift
    end

    def run
      return print_usage if @command.nil?

      case @command
      when 'local'
        Local.new(@args).run
      when 'version'
        puts "MItamae v#{MItamae::VERSION}"
      when 'help'
        print_help
      else
        puts %Q[Could not find command "#{@command}"]
        exit 1
      end
    end

    private

    def print_usage
      puts <<-USAGE
Commands:
  mitamae local RECIPE [RECIPE...]  # Run MItamae locally
  mitamae help [COMMAND]            # Describe available commands or one specific command
  mitamae version                   # Print version

Options:
  -l, [--log-level=LOG_LEVEL]  # Default: info

      USAGE
    end

    def print_help
      return print_usage if @args.empty?

      case @args.first
      when 'local'
        puts <<-HELP
Usage:
  mitamae local RECIPE [RECIPE...]

Options:
  -j, [--node-json=NODE_JSON]
  -n, [--dry-run]
      [--shell=SHELL]              # Default: /bin/sh
  -l, [--log-level=LOG_LEVEL]      # Default: info

Run MItamae locally
        HELP
      when 'version'
        puts <<-HELP
Usage:
  mitamae version

Pirnt version
        HELP
      when 'help'
        puts <<-HELP
Usage:
  mitamae help [COMMAND]

Describe available commands or one specific command
        HELP
      else
        puts %Q[Could not find command "#{@args.first}"]
        exit 1
      end
    end
  end
end
