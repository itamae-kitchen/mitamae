node.reverse_merge!({
  message: "Hello, Itamae"
})

include_recipe 'definition/example'
include_recipe 'definition/nested_params'

definition_example "name" do
  key 'value'
end

nested_params 'true'
