include_recipe 'included.rb'
include_recipe 'included.rb' # should be skipped

include_recipe 'execute'
include_recipe 'user'
include_recipe 'package'
include_recipe 'gem_package'
include_recipe 'notifies'
