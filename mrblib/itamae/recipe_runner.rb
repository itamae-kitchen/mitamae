module Itamae
  class RecipeRunner
    def initialize(options)
      @node = load_node(options[:node_json])
      @backend = Backend.new(shell: options[:shell])
      @dry_run = options[:dry_run]
      @recipes = []
    end

    def load_recipes(paths)
      backend = @backend
      paths.each do |path|
        path = File.expand_path(path)
        @recipes << Recipe.new(path).tap do |recipe|
          RecipeContext.new(
            recipe,
            node: @node,
            run_command: -> (*args) { backend.run_command(*args) },
          ).instance_eval(File.read(path), path, 1)
        end
      end
    end

    def run
      executor = RecipeExecutor.new(
        dry_run: @dry_run,
        backend: @backend,
      )

      @recipes.each do |recipe|
        executor.execute(recipe)
      end
    end

    private

    def load_node(node_json)
      Hashie::Mash.new.tap do |node|
        if node_json
          json = File.read(node_json)
          node.merge!(JSON.load(json))
        end
      end
    end
  end
end
