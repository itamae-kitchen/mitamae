require 'spec_helper'

describe 'node object' do
  before(:all) do
    apply_recipe('node', options: %w[-j /recipes/node.json])
  end

  describe file('/tmp/node_json') do
    it { should be_file }
    its(:content) { should eq('node.json') }
  end
end
