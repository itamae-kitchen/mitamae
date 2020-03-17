remote_file "/tmp/remote_file" do
  source "files/hello.txt"
end

remote_file "/tmp/remote_file_auto" do
  source :auto
  atomic_update true
end
