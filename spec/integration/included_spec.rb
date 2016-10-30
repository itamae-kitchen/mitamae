require 'spec_helper'

describe file('/tmp/included_recipe') do
  it { should be_file }
end
