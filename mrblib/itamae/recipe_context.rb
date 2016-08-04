module Itamae
  class RecipeContext
    NotFoundError = Class.new(StandardError)

    def initialize(recipe, variables = {})
      @recipe = recipe
      @variables = variables
      @variables.each do |key, value|
        if value.is_a?(Proc)
          define_singleton_method(key, &value)
        else
          define_singleton_method(key) { value }
        end
      end
    end

    def directory(path, &block)
      @recipe.children << Resource::Directory.new(path, @variables, &block)
    end

    def execute(command, &block)
      @recipe.children << Resource::Execute.new(command, @variables, &block)
    end

    def file(path, &block)
      @recipe.children << Resource::File.new(path, @variables, &block)
    end

    def git(destination, &block)
      @recipe.children << Resource::Git.new(destination, @variables, &block)
    end

    def link(link_path, &block)
      @recipe.children << Resource::Link.new(link_path, @variables, &block)
    end

    def package(name, &block)
      @recipe.children << Resource::Package.new(name, @variables, &block)
    end

    def remote_file(path, &block)
      @recipe.children << Resource::RemoteFile.new(path, @variables, &block).tap do |resource|
        resource.recipe_dir = File.dirname(@recipe.path)
      end
    end

    def service(name, &block)
      @recipe.children << Resource::Service.new(name, @variables, &block)
    end

    def define(name, params = {}, &block)
      klass = Resource::Definition.create_class(name, params)
      RecipeContext.send(:define_method, name) do |n, &b|
        @recipe.children << RecipeFromDefinition.new(name, n).tap do |recipe|
          params = klass.new(n, @variables, &b).attributes.merge(name: n)
          RecipeContext.new(recipe, params: params).instance_exec(&block)
        end
      end
    end

    def include_recipe(target)
      path = ::File.expand_path(target, File.dirname(@recipe.path))
      path = ::File.join(path, 'default.rb') if ::Dir.exists?(path)
      path.concat('.rb') unless path.end_with?('.rb')

      unless File.exist?(path)
        raise NotFoundError, "Recipe not found. (#{target})"
      end

      if @recipe.children.find { |r| r.is_a?(Recipe) && r.path == path }
        Itamae.logger.debug "Recipe, #{path}, is skipped because it is already included"
        return
      end

      @recipe.children << Recipe.new(path).tap do |recipe|
        RecipeContext.new(recipe, @variables).instance_eval(File.read(path), path, 1)
      end
    end
  end
end
