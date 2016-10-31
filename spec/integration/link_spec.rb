require 'spec_helper'

describe file('/tmp-link') do
  it { should be_linked_to '/tmp' }
  its(:content) do
    expect(subject.content.lines.size).to eq 0
  end
end

describe file('/tmp-link-force') do
  it { should be_linked_to '/tmp' }
end
