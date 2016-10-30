class Itamae::RecipeContextTest < MTest::Unit::TestCase
  def test_recipe_eval
    recipe = Itamae::Recipe.new('recipe.rb')
    script = 'package "vim"'

    assert_equal 0, recipe.children.size
    Itamae::RecipeContext.new(recipe).instance_eval(script)
    assert_equal 1, recipe.children.size
  end
end

MTest::Unit.new.mrbtest
