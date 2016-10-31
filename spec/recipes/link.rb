link "/tmp-link" do
  to "/tmp"
end

execute "touch /tmp-link-force"
link "/tmp-link-force" do
  to "/tmp"
  force true
end
