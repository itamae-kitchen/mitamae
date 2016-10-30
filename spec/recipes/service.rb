package 'nginx' do
  options '--force-yes'
end

service 'nginx' do
  action [:enable, :start]
end

execute "test -f /etc/rc3.d/S20nginx" # test
execute "test $(ps h -C nginx | wc -l) -gt 0" # test

service "nginx" do
  action [:disable, :stop]
end

execute "test ! -f /etc/rc3.d/S20nginx" # test
execute "test $(ps h -C nginx | wc -l) -eq 0" # test
