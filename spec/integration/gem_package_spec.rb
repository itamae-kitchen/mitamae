require 'spec_helper'

describe command('gem list') do
  its(:stdout) { should include('tzinfo (1.2.2, 1.1.0)') }
end

describe command('gem list') do
  its(:stdout) { should include('rake (11.1.0)') }
end

describe command('gem list') do
  its(:stdout) { should_not include('test-unit') }
end

describe command('ri Bundler') do
  its(:stderr) { should eq("Nothing known about Bundler\n") }
end
