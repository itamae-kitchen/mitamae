included_flag_file = '/tmp/included_rb_is_included'
if File.exist?(included_flag_file) && File.read(included_flag_file) == 'included'
  raise 'included.rb should not be included twice'
else
  File.open(included_flag_file, 'w').write('included')
end

execute 'touch /tmp/included_recipe'
