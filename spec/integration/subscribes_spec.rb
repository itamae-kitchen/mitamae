require 'spec_helper'

describe 'subscribes attribute' do
  before(:all) do
    apply_recipe('subscribes')
  end

  describe file('/tmp/subscribes') do
    it { should be_file }
    its(:content) { should eq("2431") }
  end

  describe file('/tmp/subscribed_from_parent') do
    it { should be_file }
  end
end
