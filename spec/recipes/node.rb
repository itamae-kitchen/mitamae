file '/tmp/node_json' do
  content node[:node_json]
end

file '/tmp/node_yml' do
  content node[:node_yml]
end

file '/tmp/node1' do
  content node[:deep][:node1]
end

file '/tmp/node2' do
  content node[:deep][:node2]
end

template '/tmp/node_assign'

template '/tmp/node_merge'

node.validate! do
  {
    deep: {
      node1: string,
      node2: string,
    },
  }
end
