require 'spec_helper'

describe command('gem list') do
  its(:stdout) { should include('tzinfo (1.2.2, 1.1.0)') }
end

describe command('gem list') do
  its(:stdout) { should include('karabiner (0.3.1)') }
end

describe command('gem list') do
  its(:stdout) { should_not include('rack-user_agent') }
end

describe command('ri Bundler') do
  its(:stderr) { should eq("Nothing known about Bundler\n") }
end
