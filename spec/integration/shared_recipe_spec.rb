require 'spec_helper'

describe 'directory resource' do
  before(:all) do
    apply_recipe('shared_recipe_a', 'shared_recipe_b')
  end

  describe file('/tmp/shared_recipe_a') do
    its(:content) { should eq('shared_recipe_a') }
  end
end
