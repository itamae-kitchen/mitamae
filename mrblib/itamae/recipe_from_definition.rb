module Itamae
  class RecipeFromDefinition < Struct.new(:resource_type, :resource_name, :children)
    def initialize(*)
      super
      self.children ||= []
    end
  end
end
