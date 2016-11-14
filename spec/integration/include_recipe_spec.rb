require 'spec_helper'

describe 'include_recipe' do
  before(:all) do
    apply_recipe('include_recipe')
  end

  describe file('/tmp/include_counter') do
    it { should be_file }
    its(:content) { should eq(".\n") }
  end
end
