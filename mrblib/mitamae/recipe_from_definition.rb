module MItamae
  class RecipeFromDefinition < Struct.new(:dir, :parent, :resource_type, :resource_name, :children, :delayed_notifications, :definition)
    def initialize(*)
      super
      self.children ||= []
      self.delayed_notifications ||= []
    end

    def root
      if parent
        parent.root
      else
        self
      end
    end
  end
end
