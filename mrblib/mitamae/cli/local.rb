module MItamae
  class CLI
    class Local
      DEFAULT_OPTIONS = {
        node_json: nil,
        node_yaml: nil,
        dry_run:   false,
        shell:     '/bin/sh',
        log_level: 'info',
      }

      def initialize(args)
        @options = DEFAULT_OPTIONS.dup
        @recipe_paths = parse_options(args)
      end

      def run
        if @recipe_paths.empty?
          puts 'Please specify recipe files.'
          exit 1
        end

        MItamae.logger = Logger.new(@options[:log_level])
        MItamae.logger.info 'Starting MItamae...'

        GC.disable # to avoid SEGV on GC
        Plugin.load_resources

        backend = Backend.new(shell: @options[:shell])
        recipes = RecipeLoader.new(
          node_json: @options[:node_json],
          backend:   backend,
        ).load(@recipe_paths)

        RecipeExecutor.new(
          dry_run: @options[:dry_run],
          backend: backend,
        ).execute(recipes)
      end

      private

      def parse_options(args)
        opt = OptionParser.new
        opt.on('-j VAL', '--node-json=VAL') { |v| @options[:node_json] = v }
        opt.on('-y VAL', '--node-yaml=VAL') { |v| @options[:node_yaml] = v }
        opt.on('-n', '--dry-run') { |v| @options[:dry_run] = v }
        opt.on('--shell=VAL')     { |v| @options[:shell] = v }
        opt.on('--log-level=VAL') { |v| @options[:log_level] = v }
        opt.parse!(args.dup)
      end
    end
  end
end
