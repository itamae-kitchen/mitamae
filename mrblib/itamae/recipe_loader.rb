module Itamae
  class RecipeLoader
    def initialize(node = {})
      @node = node
    end

    def load(path)
      Recipe.new(path).tap do |recipe|
        recipe_source = File.read(path)
        RecipeContext.new(recipe).instance_eval(recipe_source, path, 1)
      end
    end
  end
end
