node.reverse_merge!({
  message: "Hello, Itamae"
})

include_recipe 'definition/example'
include_recipe 'definition/nested_params'

definition_example '/tmp/created_by_definition' do
  key 'value'
end

definition_example '/tmp/not_created_by_definition' do
  key 'value'
  not_if 'true'
end

definition_example '/tmp/only_created_by_definition' do
  key 'value'
  only_if 'false'
end

nested_params 'true'
