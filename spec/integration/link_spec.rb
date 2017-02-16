require 'spec_helper'

describe 'link resource' do
  before(:all) do
    apply_recipe('link')
  end

  describe file('/tmp-link') do
    it { should be_linked_to '/tmp' }
    its(:content) do
      expect(subject.content.lines.size).to eq 0
    end
  end

  describe file('/tmp-link-force') do
    it { should be_linked_to '/tmp' }
  end

  describe file('/tmp/link-force-no-dereference') do
    it { should be_linked_to 'link-force-no-dereference2' }
  end
  
  describe file('/tmp/link-force-no-dereference/link-force-no-dereference2') do
    it { should_not exist }
  end
end
