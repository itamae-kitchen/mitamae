module MItamae
  class Recipe < Struct.new(:path, :children, :delayed_notifications)
    def self.load(path, variables = {})
      path = File.expand_path(path)
      Recipe.new(path).tap do |recipe|
        source = File.read(path)
        RecipeContext.new(recipe, variables).instance_eval(source, path, 1)
      end
    end

    def initialize(*)
      super
      self.children ||= []
      self.delayed_notifications ||= []
    end
  end
end
