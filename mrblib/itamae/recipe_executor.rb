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
        ResourceExecutor.find(node.class).new(node, @options).execute
      else
        raise "unexpected execute node: #{node.class}"
      end
    end

    private

    def execute_children(node)
      node.children.each do |resource|
        Itamae.logger.with_indent { execute(resource) }
      end
    end
  end
end
