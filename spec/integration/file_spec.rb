require 'spec_helper'

describe file('/tmp/file') do
  it { should be_file }
  its(:content) { should match(/Hello World/) }
  it { should be_mode 777 }
end
