include_recipe 'toplevel_module'
file '/tmp/toplevel_module' do
  content ToplevelModule.helper
end

include_recipe 'variables'
