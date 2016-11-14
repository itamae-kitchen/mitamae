require 'spec_helper'

describe 'definition' do
  before(:all) do
    apply_recipe('define')
  end

  describe file('/tmp/created_by_definition') do
    it { should be_file }
    its(:content) { should eq("name:name,key:value,message:Hello, Itamae\n") }
  end

  describe file('/tmp/remote_file_in_definition') do
    it { should be_file }
    its(:content) { should eq("definition_example\n") }
  end

  describe file('/tmp/nested_params') do
    it { should be_file }
    its(:content) { should eq("true\n") }
  end
end
