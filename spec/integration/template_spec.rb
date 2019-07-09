require 'spec_helper'

describe 'template resource' do
  before(:all) do
    apply_recipe('template', options: %w[-j /recipes/node.json])
  end

  %w!/tmp/template /tmp/template_auto!.each do |f|
    describe file(f) do
      it { should be_file }
      its(:content) { should match(/Hello/) }
      its(:content) { should match(/Good bye/) }
      # its(:content) { should match(/^total memory: \d+kB$/) }
      its(:content) { should match(/^uninitialized node key: $/) }
    end
  end

  describe file('/tmp/template_content') do
    it { should be_file }
    its(:content) { should eq("This is some foo\nThis is some bar\n") }
  end
end
