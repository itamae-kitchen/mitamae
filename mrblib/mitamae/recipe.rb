module MItamae
  class Recipe < Struct.new(:path, :parent, :children, :delayed_notifications)
    # @param path [String]
    # @param parent [MItamae::RecipeRoot]
    # @param variables [Hash]
    def self.load(path, parent, variables)
      MItamae.logger.debug "Loading recipe: #{path}"
      path = File.expand_path(path)
      Recipe.new(path, parent).tap do |recipe|
        recipe.eval_file(path, variables)
      end
    end

    def initialize(*)
      super
      self.children ||= []
      self.delayed_notifications ||= []
    end

    # XXX: The default #inspect causes SEGV...
    def inspect
      "<#{self.class}:0x#{object_id.to_s(16)}>"
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

    def eval_file(path, variables)
      src = File.read(path)
      context = RecipeContext.new(self, variables)
      InstanceEval.new(src, path, 1, receiver: context).call
    end

    # For #instance_eval with TOPLEVEL_BINDING
    class InstanceEval
      def initialize(*args, receiver:)
        @args = args
        @receiver = receiver
      end

      def call
        # When we call #instance_eval, we should not have local variables.
        # Otherwise a recipe may see the local variables by default.
        @receiver.instance_eval(*@args)
      end
    end
  end

  class RecipeRoot < Struct.new(:children)
    def root
      self
    end

    def all_resources
      children.map do |recipe|
        resources_for(recipe.children)
      end.flatten
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
      end
    end
  end
end
