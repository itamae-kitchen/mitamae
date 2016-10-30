module MItamae
  class RecipeFromDefinition < Struct.new(:resource_type, :resource_name, :children, :delayed_notifications)
    def initialize(*)
      super
      self.children ||= []
      self.delayed_notifications ||= []
    end
  end
end
