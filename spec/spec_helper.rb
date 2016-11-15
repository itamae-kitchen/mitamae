require 'serverspec'

module MItamaeSpec
  def self.container
    @container ||= ENV['DOCKER_CONTAINER'] || 'mitamae-spec'
  end

  def apply_recipe(recipe, options: [])
    recipe << '.rb' unless recipe.end_with?('.rb')
    recipe = "/recipes/#{recipe}"

    puts "\n=== Apply #{recipe} #{options.join(' ')} ==="
    system(
      'docker', 'exec', '-it', MItamaeSpec.container,
      '/mitamae/bin/mitamae', 'local', *options, recipe,
    ) || raise("Failed to apply: #{recipe}")
  end
end

set :backend, :docker
set :docker_uri, ENV['DOCKER_HOST']
set :docker_container, MItamaeSpec.container

RSpec.configure do |config|
  config.include MItamaeSpec

  config.before(:suite) do
    if ENV['SKIP_MITAMAE_COMPILE'] != '1'
      system('time', 'docker-compose', 'run', 'compile') || raise
      puts
    end

    system('docker', 'rm', '-f', MItamaeSpec.container)
    system(
      'docker', 'run', '-d', '--name', MItamaeSpec.container,
      '-v', "#{File.expand_path('mruby/build/host')}:/mitamae",
      '-v', "#{File.expand_path('spec/recipes')}:/recipes",
      'ubuntu:trusty', 'bash', '-c', 'while true; do sleep 3600; done',
    ) || raise
  end
end
