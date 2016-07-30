module Itamae
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
        puts "Itamae v#{Itamae::VERSION}"
      when 'help'
        print_help
      else
        raise %Q[Could not find command "#{@command}"]
      end
    end

    private

    def print_usage
      puts <<-USAGE
Commands:
  itamae local RECIPE [RECIPE...]  # Run Itamae locally
  itamae help [COMMAND]            # Describe available commands or one specific command
  itamae version                   # Print version

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
  itamae local RECIPE [RECIPE...]

Options:
  -j, [--node-json=NODE_JSON]
  -y, [--node-yaml=NODE_YAML]
  -n, [--dry-run]
      [--shell=SHELL]              # Default: /bin/sh
  -l, [--log-level=LOG_LEVEL]      # Default: info

Run Itamae locally
        HELP
      when 'version'
        puts <<-HELP
Usage:
  itamae version

Pirnt version
        HELP
      when 'help'
        puts <<-HELP
Usage:
  itamae help [COMMAND]

Describe available commands or one specific command
        HELP
      else
        raise %Q[Could not find command "#{@args.first}"]
      end
    end
  end
end
