require 'spec_helper'

describe 'node object' do
  before(:all) do
    apply_recipe(
      'node',
      options: %w[-j /recipes/node.json -y /recipes/node.yml -y /recipes/node2.yml],
    )
  end

  describe file('/tmp/node_json') do
    it { should be_file }
    its(:content) { should eq('node.json') }
  end

  describe file('/tmp/node_yml') do
    it { should be_file }
    its(:content) { should eq('node.yml') }
  end

  describe file('/tmp/node1') do
    it { should be_file }
    its(:content) { should eq('node1') }
  end

  describe file('/tmp/node2') do
    it { should be_file }
    its(:content) { should eq('node2') }
  end

  describe file('/tmp/node_assign') do
    it { should be_file }
    its(:content) { should eq("hello: hello\nworld: world\n") }
  end

  describe file('/tmp/node_merge') do
    it { should be_file }
    its(:content) { should eq("hello: hello\nworld: world\n" * 2) }
  end
end
