require 'spec_helper'

describe 'execute resource' do
  before(:all) do
    apply_recipe('execute')
  end

  describe file('/tmp/execute') do
    it { should be_file }
    its(:content) { should match(/Hello Execute/) }
  end

  describe file('/tmp/never_exist1') do
    it { should_not be_file }
  end

  describe file('/tmp/never_exist2') do
    it { should_not be_file }
  end
end
