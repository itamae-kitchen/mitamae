module Itamae
  class RecipeContext
    def initialize(recipe)
      @recipe = recipe
    end

    def package(name, &block)
      @recipe.children << Resource::Package.new(name, &block)
    end
  end
end
