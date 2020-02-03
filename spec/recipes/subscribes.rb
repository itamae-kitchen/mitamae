execute "echo -n > /tmp/subscribes"

execute "echo -n 1 >> /tmp/subscribes" do
  action :nothing
  subscribes :run, "execute[echo -n 2 >> /tmp/subscribes]"
end

execute "echo -n 2 >> /tmp/subscribes"

execute "echo -n 3 >> /tmp/subscribes" do
  action :nothing
  subscribes :run, "execute[echo -n 4 >> /tmp/subscribes]", :immediately
end

execute "echo -n 4 >> /tmp/subscribes"

###

include_recipe 'subscribes_child'

execute "touch /tmp/subscribed_from_parent" do
  action :nothing
  subscribes :run, 'execute[subscribed from parent]'
end

execute 'echo hello'

execute 'echo -n 1 >> /tmp/subscribes-multi' do
  action :nothing
  subscribes :run, 'execute[echo hello]'
end

execute 'echo -n 2 >> /tmp/subscribes-multi' do
  action :nothing
  subscribes :run, 'execute[echo hello]'
end
