require 'spec_helper'

describe file('/tmp/execute') do
  it { should be_file }
  its(:content) { should match(/Hello Execute/) }
end
