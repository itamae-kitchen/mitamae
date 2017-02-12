module MItamae
  class RecipeLoader
    def initialize(options)
      @backend = options[:backend]
      @node = build_node(options[:node_json], options[:node_yaml], @backend)
    end

    # @return [Array<MItamae::Recipe>]
    def load(paths)
      backend = @backend
      variables = {
        node: @node,
        run_command: -> (*args) { backend.run_command(*args) },
      }

      root = RecipeRoot.new
      paths.map do |path|
        Recipe.load(path, root, variables)
      end.tap do |recipes|
        root.children = recipes
      end
    end

    private

    def build_node(node_json, node_yaml, backend)
      Node.new({}, backend).tap do |node|
        if node_json
          json = File.read(node_json)
          node.reverse_merge!(JSON.load(json))
        end
        if node_yaml
          yaml = File.read(node_yaml)
          node.reverse_merge!(YAML.load(yaml))
        end
      end
    end
  end
end
