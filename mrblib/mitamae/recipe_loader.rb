module MItamae
  class RecipeLoader
    def initialize(options)
      @backend = options[:backend]
      @node = build_node(options[:node_jsons], options[:node_yamls], @backend)
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

    def build_node(node_jsons, node_yamls, backend)
      Node.new({}, backend).tap do |node|
        node_jsons.each do |node_json|
          json = File.read(node_json)
          node.merge!(JSON.load(json))
        end
        node_yamls.each do |node_yaml|
          yaml = File.read(node_yaml)
          node.merge!(YAML.load(yaml))
        end
      end
    end
  end
end
