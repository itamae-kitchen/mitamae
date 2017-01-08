execute "echo 'Hello Execute' > /tmp/execute"

execute 'Array Command' do
  command ['touch', '/tmp/execute_array']
end
