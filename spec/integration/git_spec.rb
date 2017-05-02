require 'spec_helper'

describe 'git resource' do
  before(:all) do
    apply_recipe('git')
  end

  describe command('cd /tmp/git_repo && git rev-parse HEAD') do
    its(:stdout) { should match(/3116e170b89dc0f7315b69c1c1e1fd7fab23ac0d/) }
  end

  describe command('cd /tmp/git_repo_submodule/empty_repo && cat README.md') do
    its(:stdout) { should match(/Empty Repo/) }
  end

  describe command('cd /tmp/fake_depth_repo && git rev-list --count HEAD') do
    its(:stdout) { should eq "1\n" }
  end
end
