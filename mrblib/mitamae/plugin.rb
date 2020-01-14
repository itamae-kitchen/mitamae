module MItamae
  module Plugin
    # Put a plugin repository under `plugins/` as git submodule or just copy it.
    class << self
      attr_accessor :plugins_path

      # Load plugins/{,m}itamae-plugin-resource-*/mrblib/**/*.rb before running recipes.
      def load_resources
        if File.directory?(plugins_path)
          Dir.glob(File.join(plugins_path, '{,m}itamae-plugin-resource-*/mrblib/**/*.rb')).sort.each do |source|
            eval(File.read(source), nil, source)
          end
        end
      end

      # Find recipe from:
      # [when target is `name`]       plugins/{,m}itamae-plugin-recipe-#{name}/mrblib/{,m}itamae/plugin/recipe/#{name}{/default,}.rb
      # [when target is `name::file`] plugins/{,m}itamae-plugin-recipe-#{name}/mrblib/{,m}itamae/plugin/recipe/#{name}/#{file}.rb
      #
      # See also: https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/recipe.rb#L13-L42
      def find_recipe(target)
        recipe_candidates(target).find do |path|
          File.exist?(path)
        end
      end

      private

      def recipe_candidates(target)
        name, recipe_file = target.split('::', 2)
        if recipe_file
          recipe_file = recipe_file.gsub("::", "/")
          recipe_file << '.rb' unless recipe_file.end_with?('.rb')
          Dir.glob(File.join(plugins_path, "{,m}itamae-plugin-recipe-#{name}/mrblib/{,m}itamae/plugin/recipe/#{name}/#{recipe_file}"))
        else
          Dir.glob(File.join(plugins_path, "{,m}itamae-plugin-recipe-#{name}/mrblib/{,m}itamae/plugin/recipe/#{name}{/default,}.rb"))
        end
      end
    end

    # Define resource plugins under `MItamae::Plugin::Resource::`.
    module Resource
      def self.resource_plugin?(klass)
        klass.to_s =~ /\AMItamae::Plugin::Resource::[a-zA-Z\d]+\z/
      end
    end

    # Define resource executor plugins under `MItamae::Plugin::ResourceExecutor::`.
    module ResourceExecutor
      def self.find(klass)
        const_get(klass.to_s.sub(/\AMItamae::Plugin::Resource::/, ''))
      end
    end
  end
end
