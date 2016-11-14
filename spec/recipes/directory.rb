include_recipe 'user'

directory "/tmp/directory" do
  mode "700"
  owner "itamae"
  group "itamae"
end

directory "/tmp/directory_never_exist1" do
  action :create
end

directory "/tmp/directory_never_exist1" do
  action :delete
end
