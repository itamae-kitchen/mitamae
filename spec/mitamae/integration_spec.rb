require 'spec_helper'

describe package('bash') do
  it { should be_installed }
end
