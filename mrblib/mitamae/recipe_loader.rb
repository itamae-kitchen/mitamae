module MItamae
  class RecipeLoader
    def initialize(options)
      @backend = options[:backend]
      @node    = build_node(options[:node_json], @backend)
    end

    def load(paths)
      backend = @backend
      variables = {
        node: @node,
        run_command: -> (*args) { backend.run_command(*args) },
      }

      paths.map do |path|
        Recipe.load(path, variables)
      end
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
