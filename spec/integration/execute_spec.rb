require 'spec_helper'

describe file('/tmp/execute_resource') do
  its(:content) { should eq("hello\n") }
  it { should exist }
end
