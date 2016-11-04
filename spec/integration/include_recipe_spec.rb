require 'spec_helper'

describe file('/tmp/include_counter') do
  it { should be_file }
  its(:content) { should eq(".\n") }
end
