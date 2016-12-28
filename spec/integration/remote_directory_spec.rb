require 'spec_helper'

describe 'remote_directory resource' do
  before(:all) do
    apply_recipe('remote_directory')
  end

  describe file('/tmp/remdir') do
    it { should be_directory }
  end

  describe file('/tmp/remdir/file') do
    it { should be_file }
    its(:content) { should eq("Hello\n") }
  end

  context 'when desired directory exists' do
    before(:all) do
      apply_recipe('remote_directory')
      apply_recipe('remote_directory') # Do twice
    end

    describe file('/tmp/remdir') do
      it { should be_directory }
    end
  
    describe file('/tmp/remdir/file') do
      it { should be_file }
      its(:content) { should eq("Hello\n") }
    end
  end
end
