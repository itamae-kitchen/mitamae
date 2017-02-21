link "/tmp-link" do
  to "/tmp"
end

execute "touch /tmp-link-force"
link "/tmp-link-force" do
  to "/tmp"
  force true
end

execute "mkdir /tmp/link-force-no-dereference1"
link "link-force-no-dereference" do
  cwd "/tmp"
  to "link-force-no-dereference1"
  force true
end

execute "mkdir /tmp/link-force-no-dereference2"
link "link-force-no-dereference" do
  cwd "/tmp"
  to "link-force-no-dereference2"
  force true
end

