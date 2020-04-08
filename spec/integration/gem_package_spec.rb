require 'spec_helper'

describe 'gem_package resource' do
  before(:all) do
    apply_recipe('gem_package')
  end

  describe command('gem list') do
    its(:stdout) { should include('tzinfo (1.2.2, 1.1.0)') }
  end

  describe command('gem list') do
    its(:stdout) { should include('unindent (0.9)') }
  end

  describe command('gem list') do
    its(:stdout) { should_not include('perf') }
  end

  describe command('ri Rake') do
    its(:stderr) { should eq("Nothing known about Rake\n") }
  end

  describe file('/tmp/bundler_is_installed') do
    it { should_not be_file }
  end

  it 'exits abnormally when inexistent gem command is specified' do
    expect { apply_recipe('gem_package_error') }.to raise_error(RuntimeError)
  end
end
