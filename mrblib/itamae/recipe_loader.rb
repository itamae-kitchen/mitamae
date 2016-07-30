module Itamae
  class RecipeLoader
    def initialize(node = {})
      @node = node
    end

    def load(path)
      Recipe.new(path)
    end
  end
end
