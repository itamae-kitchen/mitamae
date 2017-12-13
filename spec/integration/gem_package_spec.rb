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
    its(:stdout) { should_not include('itamae-template') }
  end

  describe command('ri Rake') do
    its(:stderr) { should eq("Nothing known about Rake\n") }
  end

  describe file('/tmp/bundler_is_installed') do
    it { should_not be_file }
  end
end
