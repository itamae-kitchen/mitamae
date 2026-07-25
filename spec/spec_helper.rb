require 'fileutils'
require 'serverspec'

module MItamaeSpec
  TARGET = 'linux-x86_64'
  # Serving the httpbin API ourselves keeps the http_request specs from depending on a third-party service.
  HTTPBIN_IMAGE = 'ghcr.io/mccutchen/go-httpbin:2.24.0'

  class << self
    def container
      @container ||= ENV.fetch('DOCKER_CONTAINER', 'mitamae-serverspec')
    end

    def network
      "#{container}-net"
    end

    def httpbin
      "#{container}-httpbin"
    end

    def httpbin_tls
      "#{container}-httpbin-tls"
    end

    def cert_dir
      File.expand_path('spec/tmp/certs')
    end

    # The recipes reach go-httpbin by its network alias, so the certificate must be issued for that name.
    def generate_certificate
      FileUtils.rm_rf(cert_dir)
      FileUtils.mkdir_p(cert_dir)
      system(
        'openssl', 'req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-days', '365',
        '-subj', '/CN=httpbin-tls', '-addext', 'subjectAltName=DNS:httpbin-tls',
        '-keyout', "#{cert_dir}/key.pem", '-out', "#{cert_dir}/cert.pem",
        out: File::NULL, err: File::NULL, exception: true,
      )
      # The go-httpbin image runs as a non-root user, so the mounted files have to be world-readable.
      FileUtils.chmod(0o644, ["#{cert_dir}/cert.pem", "#{cert_dir}/key.pem"])
    end

    def wait_for_httpbin(name, timeout: 30)
      deadline = Time.now + timeout
      loop do
        logs = IO.popen(['docker', 'logs', name], err: [:child, :out], &:read)
        return if logs.include?('go-httpbin listening on')
        raise "#{name} did not start listening in #{timeout}s:\n#{logs}" if Time.now > deadline

        sleep 0.2
      end
    end

    # systemd wipes /tmp while booting, so commands that write there (`update-ca-certificates`)
    # fail unless we let it settle first.
    def wait_for_systemd(timeout: 30)
      deadline = Time.now + timeout
      loop do
        state = IO.popen(
          ['docker', 'exec', container, 'systemctl', 'is-system-running', '--wait'],
          err: [:child, :out], &:read
        ).strip
        return if %w[running degraded].include?(state)
        raise "systemd in #{container} did not finish booting in #{timeout}s: #{state}" if Time.now > deadline

        sleep 0.2
      end
    end
  end

  def apply_recipe(*recipes, cwd: '/', options: [], redirect: {})
    recipes = recipes.map do |recipe|
      recipe = "#{recipe}.rb" unless recipe.end_with?('.rb')
      "/recipes/#{recipe}"
    end

    puts "\n=== Apply #{recipes.join(' ')} #{options.join(' ')} ==="
    run_command('/mitamae/bin/mitamae', 'local', *options, *recipes, cwd: cwd, redirect: redirect)
  end

  def run_command(*cmd, cwd: '/', redirect: {})
    system('docker', 'exec', '-w', cwd, MItamaeSpec.container, *cmd, redirect) || raise("Failed to execute: #{cmd.inspect}")
  end
end

set :backend, :docker
set :docker_uri, ENV['DOCKER_HOST']
set :docker_container, MItamaeSpec.container

RSpec.configure do |config|
  config.include MItamaeSpec

  config.before(:suite) do
    if ENV['SKIP_MITAMAE_COMPILE'] != '1'
      system('rake', 'compile', "BUILD_TARGET=#{MItamaeSpec::TARGET}", exception: true)
    end

    system('docker', 'rm', '-f', MItamaeSpec.container, MItamaeSpec.httpbin, MItamaeSpec.httpbin_tls)
    system('docker', 'network', 'rm', MItamaeSpec.network, out: File::NULL, err: File::NULL)
    system('docker', 'network', 'create', MItamaeSpec.network, out: File::NULL, exception: true)

    MItamaeSpec.generate_certificate

    system(
      'docker', 'run', '-d', '--rm', '--name', MItamaeSpec.httpbin,
      '--network', MItamaeSpec.network, '--network-alias', 'httpbin',
      MItamaeSpec::HTTPBIN_IMAGE, '-port', '8080',
      out: File::NULL,
    ) || raise
    # go-httpbin serves either HTTP or HTTPS per process, so HTTPS needs a second instance.
    system(
      'docker', 'run', '-d', '--rm', '--name', MItamaeSpec.httpbin_tls,
      '--network', MItamaeSpec.network, '--network-alias', 'httpbin-tls',
      '-v', "#{MItamaeSpec.cert_dir}:/certs:ro",
      MItamaeSpec::HTTPBIN_IMAGE, '-port', '8443',
      '-https-cert-file', '/certs/cert.pem', '-https-key-file', '/certs/key.pem',
      out: File::NULL,
    ) || raise
    MItamaeSpec.wait_for_httpbin(MItamaeSpec.httpbin)
    MItamaeSpec.wait_for_httpbin(MItamaeSpec.httpbin_tls)

    # k0kubun/mitamae-spec is automatically built from `spec/Dockerfile`:
    # https://hub.docker.com/r/k0kubun/mitamae-spec/builds/
    system(
      'docker', 'run', '-d', '--privileged', '--rm', '--name', MItamaeSpec.container,
      '--network', MItamaeSpec.network,
      '-v', "#{File.expand_path("mruby/build/#{MItamaeSpec::TARGET}")}:/mitamae",
      '-v', "#{File.expand_path('spec/recipes')}:/recipes",
      '-v', "#{File.expand_path('spec/plugins')}:/plugins",
      '-v', "#{MItamaeSpec.cert_dir}:/certs:ro",
      'k0kubun/mitamae-spec', 'systemd',
    ) || raise
    MItamaeSpec.wait_for_systemd
    # Let `curl` in the container trust the self-signed certificate of httpbin-tls
    system('docker', 'exec', MItamaeSpec.container, 'cp', '/certs/cert.pem', '/usr/local/share/ca-certificates/httpbin-tls.crt', exception: true)
    system('docker', 'exec', MItamaeSpec.container, 'update-ca-certificates', out: File::NULL, exception: true)
    # Workaround to avoid letting systemd clean up /tmp after `mitamae local`
    system('docker', 'exec', MItamaeSpec.container, 'systemctl', 'start', 'systemd-tmpfiles-clean', out: File::NULL)
  end

  config.after(:suite) do
    FileUtils.rm_rf(MItamaeSpec.cert_dir)
  end
end
