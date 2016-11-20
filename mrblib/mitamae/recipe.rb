module MItamae
  class Recipe < Struct.new(:path, :parent, :children, :delayed_notifications)
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

    def dir
      File.dirname(path)
    end

    def root
      if parent
        parent.root
      else
        self
      end
    end

    def all_resources
      resources_for(children)
    end

    def subscriptions_for(target)
      all_resources.map do |resource|
        resource.subscriptions.select do |subscription|
          subscription.resource == target
        end
      end.flatten
    end

    private

    def resources_for(nodes)
      nodes.map do |node|
        case node
        when Recipe, RecipeFromDefinition
          resources_for(node.children)
        when Resource::Base
          node
        else
          raise "unexpected node: #{node.class}"
        end
      end.flatten
    end
  end
end
