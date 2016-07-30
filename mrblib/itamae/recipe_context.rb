module Itamae
  class RecipeContext
    def initialize(recipe)
      @recipe = recipe
    end

    def execute(command, &block)
      @recipe.children << Resource::Execute.new(command, &block)
    end

    def package(name, &block)
      @recipe.children << Resource::Package.new(name, &block)
    end
  end
end
