require 'spec_helper'

describe 'namespace' do
  before(:all) do
    apply_recipe('namespace')
  end

  describe file('/tmp/toplevel_module') do
    it { should exist }
    it { should be_file }
    its(:content) { should eq 'helper' }
  end

  describe file('/tmp/instance_variables') do
    it { should exist }
    it { should be_file }
    # @recipe is for backward compatibility. @variables should not be defined.
    its(:content) { should eq '[:@recipe, :@variables]' }
  end
end
