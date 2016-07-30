module Itamae
  class RecipeContext
    NotFoundError = Class.new(StandardError)

    def initialize(recipe)
      @recipe = recipe
    end

    def execute(command, &block)
      @recipe.children << Resource::Execute.new(command, &block)
    end

    def package(name, &block)
      @recipe.children << Resource::Package.new(name, &block)
    end

    def include_recipe(target)
      expanded_path = ::File.expand_path(target, File.dirname(@recipe.path))
      expanded_path = ::File.join(expanded_path, 'default.rb') if ::Dir.exists?(expanded_path)
      expanded_path.concat('.rb') unless expanded_path.end_with?('.rb')

      unless File.exist?(expanded_path)
        raise NotFoundError, "Recipe not found. (#{target})"
      end

      if @recipe.children.find { |r| r.is_a?(Recipe) && r.path == expanded_path }
        # Itamae.logger.debug "Recipe, #{path}, is skipped because it is already included"
        return
      end

      @recipe.children << RecipeLoader.new.load(expanded_path)
    end
  end
end
