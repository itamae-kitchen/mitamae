template "/tmp/template" do
  source "templates/hello.erb"
  variables goodbye: "Good bye"
end

template "/tmp/template_auto" do
  source :auto
  variables goodbye: "Good bye"
end
