module Itamae
  class RecipeExecutor
    def initialize(recipes, options)
      @recipes = recipes
      @shell   = options[:shell]
      @log_level = options[:log_level]
    end

    def execute
      puts 'execute (stubbed)'
    end

    def dry_run
      puts 'dry_run (stubbed)'
    end
  end
end
