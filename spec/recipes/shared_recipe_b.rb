execute 'true' do
  notifies :create, 'file[/tmp/shared_recipe_a]'
end
