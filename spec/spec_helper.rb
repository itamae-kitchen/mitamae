require 'serverspec'

set :backend, :docker
set :docker_uri, ENV['DOCKER_HOST']
set :docker_container, ENV['DOCKER_CONTAINER']
