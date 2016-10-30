class Itamae::ResourceContextTest < MTest::Unit::TestCase
  def test_resource_eval
    recipe   = Itamae::Recipe.new('recipe.rb')
    resource = Itamae::Resource::Package.new('vim', recipe)
    script   = 'action :remove'

    assert_equal :install, resource.attributes[:action]
    Itamae::ResourceContext.new(resource).instance_eval(script)
    assert_equal :remove, resource.attributes[:action]
  end
end

MTest::Unit.new.mrbtest
