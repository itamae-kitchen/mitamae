include_recipe 'included.rb'
include_recipe 'included.rb' # should be skipped

include_recipe 'user'
include_recipe 'directory'
include_recipe 'execute'
include_recipe 'file'
include_recipe 'link'
include_recipe 'notifies'
include_recipe 'remote_file'
include_recipe 'run_command'

# Slow recipes are executed separately. See Dockerfile.
# include_recipe 'package'
# include_recipe 'service'
# include_recipe 'gem_package'
# include_recipe 'git'
