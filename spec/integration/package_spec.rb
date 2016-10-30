require 'spec_helper'

describe package('dstat') do
  it { should be_installed }
end

describe package('sl') do
  it { should be_installed }
end

describe package('resolvconf') do
  it { should_not be_installed }
end
