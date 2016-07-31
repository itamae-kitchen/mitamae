module Itamae
  class RecipeExecutor
    def initialize(options = {})
      @options = options
    end

    def execute(node)
      notify(node)

      case node
      when Recipe, RecipeFromDefinition
        node.children.each do |resource|
          Itamae.logger.with_indent { execute(resource) }
        end
      when Resource::Base
        Itamae.logger.with_indent do
          Executor.find(node.class).new(@options).execute
        end
      else
        raise "unexpected execute node: #{node.class}"
      end
    end

    private

    def notify(node)
      case node
      when Recipe
        Itamae.logger.info "Recipe: #{node.path}"
      when RecipeFromDefinition
        Itamae.logger.info "#{node.definition_name}[#{node.resource_name}]"
      when Resource::Base
        underscore = node.class.to_s.split("::").last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
        Itamae.logger.info "#{underscore}[#{node.resource_name}]"
      else
        raise "unexpected notify node: #{node.class}"
      end
    end
  end
end
