module MItamae
  class CLI
    class Local
      DEFAULT_OPTIONS = {
        node_jsons: [],
        node_yamls: [],
        dry_run:   false,
        shell:     '/bin/sh',
        log_level: 'info',
        plugins:   './plugins',
        color:     true,
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

        MItamae.logger = Logger.new(@options[:log_level], colored: @options[:color])
        MItamae.logger.info 'Starting mitamae...'

        Plugin.plugins_path = File.expand_path(@options[:plugins])
        Plugin.load_resources

        backend = Backend.new(shell: @options[:shell])
        recipes = RecipeLoader.new(
          node_jsons: @options[:node_jsons],
          node_yamls: @options[:node_yamls],
          backend:    backend,
        ).load(@recipe_paths)

        inline_backend = InlineBackend.new
        runner = Runner.new(dry_run: @options[:dry_run], backend: backend, inline_backend: inline_backend)
        RecipeExecutor.new(runner).execute(recipes)
      end

      private

      def parse_options(args)
        opt = OptionParser.new
        opt.on('-j VAL', '--node-json=VAL') { |v| @options[:node_jsons] << v }
        opt.on('-y VAL', '--node-yaml=VAL') { |v| @options[:node_yamls] << v }
        opt.on('-n', '--dry-run') { |v| @options[:dry_run] = v }
        opt.on('--shell=VAL')     { |v| @options[:shell] = v }
        opt.on('--log-level=VAL') { |v| @options[:log_level] = v }
        opt.on('--plugins=VAL')   { |v| @options[:plugins] = v }
        opt.on('--color')         { |v| @options[:color] = true }
        opt.on('--no-color')      { |v| @options[:color] = false }
        opt.parse!(args.dup)
      end
    end
  end
end
