require 'serverspec'

module MItamaeSpec
  def self.container
    @container ||= ENV['DOCKER_CONTAINER'] || 'mitamae-serverspec'
  end

  def apply_recipe(*recipes, options: [])
    recipes = recipes.map do |recipe|
      recipe = "#{recipe}.rb" unless recipe.end_with?('.rb')
      "/recipes/#{recipe}"
    end

    puts "\n=== Apply #{recipes.join(' ')} #{options.join(' ')} ==="
    run_command('/mitamae/bin/mitamae', 'local', *options, *recipes)
  end

  def run_command(*cmd)
    system('docker', 'exec', '-it', MItamaeSpec.container, *cmd) || raise("Failed to execute: #{cmd.inspect}")
  end
end

set :backend, :docker
set :docker_uri, ENV['DOCKER_HOST']
set :docker_container, MItamaeSpec.container

RSpec.configure do |config|
  config.include MItamaeSpec

  config.before(:suite) do
    if ENV['SKIP_MITAMAE_COMPILE'] != '1'
      system('docker-compose', 'run', 'compile') || raise
    end
    system('docker', 'rm', '-f', MItamaeSpec.container)

    # k0kubun/mitamae-spec is automatically built from `spec/Dockerfile`:
    # https://hub.docker.com/r/k0kubun/mitamae-spec/builds/
    system(
      'docker', 'run', '-d', '--name', MItamaeSpec.container,
      '-v', "#{File.expand_path('mruby/build/host')}:/mitamae",
      '-v', "#{File.expand_path('spec/recipes')}:/recipes",
      'k0kubun/mitamae-spec', 'bash', '-c', 'while true; do sleep 3600; done',
    ) || raise
  end
end
