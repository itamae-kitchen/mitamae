node.reverse_merge!(
  variables: {
    # #binding is not supported in mruby
    # lvars: binding.local_variables,
    ivars: instance_variables,
  }
)

# file '/tmp/local_variables' do
#   content node[:variables][:lvars].to_s
# end

file '/tmp/instance_variables' do
  content node[:variables][:ivars].to_s
end
