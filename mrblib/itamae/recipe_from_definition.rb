module Itamae
  class RecipeFromDefinition < Struct.new(:definition_name, :resource_name, :children)
    def initialize(*)
      super
      self.children ||= []
    end
  end
end
