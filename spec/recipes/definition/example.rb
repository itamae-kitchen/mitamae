define :definition_example, key: 'default' do
  execute "echo 'key:#{params[:key]},message:#{node[:message]}' > #{params[:name].shellescape}"

  remote_file '/tmp/remote_file_in_definition'
end
