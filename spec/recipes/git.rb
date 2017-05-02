git "/tmp/git_repo" do
  repository "https://github.com/ryotarai/infrataster.git"
  revision "v0.1.0"
end

git "/tmp/git_repo_submodule" do
  repository "https://github.com/mmasaki/fake_repo_including_submodule.git"
  recursive true
end

git "/tmp/fake_depth_repo" do
  repository "https://github.com/hatappi/fake_depth_repo.git"
  depth 1
end
