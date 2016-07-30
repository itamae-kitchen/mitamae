module Itamae
  class Runner
    def initialize(options = {})
      @node = load_node(options[:node_json])
      @recipes = []
    end

    def load_recipes(paths)
      loader = RecipeLoader.new(@node)
      paths.each do |path|
        @recipes << loader.load(File.expand_path(path))
      end
    end

    def run(options = {})
      p @recipes
    end

    private

    def load_node(node_json)
      node = Hashie::Mash.new
      if node_json
        json = File.read(node_json)
        node.merge!(JSON.load(json))
      end
    end
  end
end
