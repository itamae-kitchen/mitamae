require 'spec_helper'

describe file('/tmp/hello') do
  it { should exist }
end
