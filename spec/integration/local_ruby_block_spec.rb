require 'spec_helper'

describe 'local_ruby_block resource' do
  before(:all) do
    apply_recipe('local_ruby_block')
  end

  describe file('/tmp/local_ruby_block_executed') do
    it { should be_file }
  end

  describe file('/tmp/local_ruby_block_notified') do
    it { should be_file }
  end

  describe file('/tmp/local_ruby_block_nothing') do
    it { should_not be_file }
  end
end
