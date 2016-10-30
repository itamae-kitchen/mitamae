require 'spec_helper'

describe file('/tmp/notifies') do
  it { should be_file }
  its(:content) { should eq("2431") }
end
