include_recipe 'include_recipe'
include_recipe 'link'
include_recipe 'notifies'
include_recipe 'remote_file'
include_recipe 'run_command'
include_recipe 'template'

# Slow recipes are executed separately. See Dockerfile.
# include_recipe 'package'
# include_recipe 'service'
# include_recipe 'gem_package'
# include_recipe 'git'
