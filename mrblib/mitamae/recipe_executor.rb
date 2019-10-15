module MItamae
  class RecipeExecutor
    def initialize(runner)
      @runner = runner
    end

    def execute(recipes)
      recipes.each do |recipe|
        execute_node(recipe)
      end
    end

    private

    def execute_node(node)
      case node
      when Recipe
        MItamae.logger.info "Recipe: #{node.path}"
        execute_children(node)
      when RecipeFromDefinition
        unless ResourceExecutor.create(node.definition, @runner).skip_condition?
          MItamae.logger.debug "#{node.resource_type}[#{node.resource_name}]"
          execute_children(node)
        end
      when Resource::Base
        ResourceExecutor.create(node, @runner).execute
      else
        raise "unexpected execute node: #{node.class}"
      end
    end

    def execute_children(node)
      MItamae.logger.with_indent do
        node.children.each do |resource|
          execute_node(resource)
        end
        node.delayed_notifications.uniq { |n| [n.action, n.target_resource_desc] }.each do |notification|
          ResourceExecutor.create(notification.action_resource, @runner).execute(notification.action)
        end
      end
    end
  end
end
