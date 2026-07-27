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

file '/tmp/node_method' do
  content node.node_json
end

file '/tmp/node_fetch' do
  content node.fetch('node_yml')
end

file '/tmp/node_fetch_missing' do
  content(
    begin
      node.fetch('missing_key')
      'no error'
    rescue KeyError
      'KeyError'
    end
  )
end

file '/tmp/node_to_h' do
  content node.to_h.keys.sort.join(',')
end

file '/tmp/node_respond_to' do
  content [node.respond_to?(:node_json), node.respond_to?(:missing_key)].join(',')
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
