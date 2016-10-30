class MItamae::ResourceContextTest < MTest::Unit::TestCase
  def test_resource_eval
    recipe   = MItamae::Recipe.new('recipe.rb')
    resource = MItamae::Resource::Package.new('vim', recipe)
    script   = 'action :remove'

    assert_equal :install, resource.attributes[:action]
    MItamae::ResourceContext.new(resource).instance_eval(script)
    assert_equal :remove, resource.attributes[:action]
  end
end

MTest::Unit.new.mrbtest
