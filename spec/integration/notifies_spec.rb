require 'spec_helper'

describe 'notifies attribute' do
  before(:all) do
    apply_recipe('notifies')
  end

  describe file('/tmp/notifies') do
    it { should be_file }
    its(:content) { should eq("2431") }
  end
end
