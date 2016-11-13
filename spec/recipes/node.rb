file '/tmp/node_json' do
  content node[:node_json]
end

file '/tmp/node_yaml' do
  content node[:node_yml]
end
