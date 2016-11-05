module MItamae
  class RecipeLoader
    def initialize(options)
      @backend = options[:backend]
      @node    = build_node(options[:node_json], @backend)
      @dry_run = options[:dry_run]
    end

    def load(paths)
      recipes = []
      backend = @backend

      paths.each do |path|
        path = File.expand_path(path)
        recipes << Recipe.new(path).tap do |recipe|
          RecipeContext.new(
            recipe,
            node: @node,
            run_command: -> (*args) { backend.run_command(*args) },
          ).instance_eval(File.read(path), path, 1)
        end
      end
      recipes
    end

    private

    def build_node(node_json, backend)
      Node.new({}, backend).tap do |node|
        if node_json
          json = File.read(node_json)
          node.merge!(JSON.load(json))
        end
      end
    end
  end
end
