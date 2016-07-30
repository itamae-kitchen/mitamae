module Itamae
  class Runner
    def initialize(node = {})
      @node = node
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
  end
end
