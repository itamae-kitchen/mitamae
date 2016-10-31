require 'spec_helper'

describe file('/tmp/directory') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by "itamae" }
  it { should be_grouped_into "itamae" }
end

describe file('/tmp/directory_never_exist1') do
  it { should_not be_directory }
end
