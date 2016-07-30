module Itamae
  class Runner
    def initialize(options = {})
      @node = load_node(options[:node_json])
      @recipes = []
    end

    def load_recipes(paths)
      paths.each do |path|
        path = File.expand_path(path)
        @recipes << Recipe.new(path).tap do |recipe|
          RecipeContext.new(recipe, node: @node).instance_eval(File.read(path), path, 1)
        end
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
