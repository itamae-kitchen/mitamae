node.reverse_merge!({
  message: "Hello, Itamae"
})

include_recipe 'definition/example'

definition_example "name" do
  key 'value'
end
