template "/tmp/template" do
  source "templates/hello.erb"
  variables goodbye: "Good bye"
end

template "/tmp/template_auto" do
  source :auto
  variables goodbye: "Good bye"
end

template "/tmp/template_content" do
  content <<-CONTENT
<% @things.each do |thing| -%>
This is some <%= thing %>
<% end -%>
  CONTENT
  variables(
    things: ['foo', 'bar']
  )
end
