service 'nginx' do
  action [:enable, :start]
end

execute "test -f /etc/systemd/system/multi-user.target.wants/nginx.service" # test
execute "test $(ps h -C nginx | wc -l) -gt 0" # test

service "nginx" do
  action [:disable, :stop]
end

execute "test ! -f /etc/systemd/system/multi-user.target.wants/nginx.service" # test
execute "test $(ps h -C nginx | wc -l) -eq 0" # test
