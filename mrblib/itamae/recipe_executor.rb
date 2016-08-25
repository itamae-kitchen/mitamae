module Itamae
  class RecipeExecutor
    def initialize(options = {})
      @options = options
    end

    def execute(node)
      case node
      when Recipe
        Itamae.logger.info "Recipe: #{node.path}"
        execute_children(node)
      when RecipeFromDefinition
        Itamae.logger.debug "#{node.resource_type}[#{node.resource_name}]"
        execute_children(node)
      when Resource::Base
        ResourceExecutor.create(node, @options).execute
      else
        raise "unexpected execute node: #{node.class}"
      end
    end

    private

    def execute_children(node)
      Itamae.logger.with_indent do
        node.children.each do |resource|
          execute(resource)
        end
        node.delayed_notifications.each do |notification|
          ResourceExecutor.create(notification.resource, @options).execute(notification.action)
        end
      end
    end
  end
end
