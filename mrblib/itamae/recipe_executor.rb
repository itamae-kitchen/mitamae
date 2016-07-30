module Itamae
  class RecipeExecutor
    def initialize(recipes, options)
      @recipes = recipes
      @shell   = options[:shell]
    end

    def execute
      @recipes.each do |recipe|
        log(recipe)
      end
    end

    def dry_run
      @recipes.each do |recipe|
        log(recipe)
      end
    end

    private

    def log(object)
      case object
      when Recipe
        Itamae.logger.info "Recipe: #{object.path}"
      else
        raise 'unexpected log resource'
      end
    end
  end
end
