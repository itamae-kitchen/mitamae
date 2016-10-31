include_recipe 'included.rb'
include_recipe 'included.rb' # should be skipped

include_recipe 'execute'
include_recipe 'file'
include_recipe 'gem_package'
include_recipe 'notifies'
include_recipe 'package'
include_recipe 'remote_file'
include_recipe 'service'
include_recipe 'user'
