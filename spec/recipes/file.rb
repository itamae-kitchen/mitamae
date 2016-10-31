file "/tmp/file" do
  content "Hello World"
  mode "777"
end

file "/tmp/never_exist1" do
  only_if "exit 1"
end

file "/tmp/never_exist2" do
  not_if "exit 0"
end
