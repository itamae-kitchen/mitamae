require 'fileutils'

file 'mruby/.git' do
  # Using master to apply https://github.com/mruby/mruby/pull/3192
  sh "git submodule init && git submodule update"

  #sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/1.2.0.tar.gz -s -o - | tar zxf -"
  #FileUtils.mv("mruby-1.2.0", "mruby")
end

APP_NAME=ENV["APP_NAME"] || "mitamae"
APP_ROOT=ENV["APP_ROOT"] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task['mruby/.git'].invoke unless Dir.exist?(File.join(mruby_root, '.git'))
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

desc "compile binary"
task :compile => [:all] do
  %W(#{mruby_root}/build/x86_64-pc-linux-gnu/bin/#{APP_NAME} #{mruby_root}/build/i686-pc-linux-gnu/#{APP_NAME}").each do |bin|
    sh "strip --strip-unneeded #{bin}" if File.exist?(bin)
  end
  FileUtils.rm_f("#{mruby_root}/mkmf.log") # mkmf.log makes submodule dirty
end

namespace :test do
  desc "run mruby & unit tests"
  # only build mtest for host
  task :mtest => :compile do
    # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
    # we need to make sure the tests are built relative from mruby_root
    MRuby.each_target do |target|
      # only run unit tests here
      target.enable_bintest = false
      run_test if target.test_enabled?
    end
  end

  def clean_env(envs)
    old_env = {}
    envs.each do |key|
      old_env[key] = ENV[key]
      ENV[key] = nil
    end
    yield
    envs.each do |key|
      ENV[key] = old_env[key]
    end
  end

  ENV['DOCKER_CONTAINER'] ||= 'mitamae-spec'
  desc 'run spec container'
  task :compile do
    Dir.chdir(__dir__) do
      sh 'docker-compose run -e BUILD_TARGET=linux-x86_64 compile'
    end
  end

  desc 'run bundle install'
  task :bundle_install do
    Dir.chdir(__dir__) do
      sh 'bundle check || bundle install -j4'
    end
  end

  desc 'run serverspec'
  task :serverspec => :bundle_install do
    Dir.chdir(__dir__) do
      sh 'bundle exec rspec'
    end
  end

  desc 'run integration tests'
  task integration: :serverspec

  desc 'Benchmark recipe execution'
  task benchmark: :compile do
    Dir.chdir(__dir__) do
      ENV['MITAMAE_BENCH_ITERATIONS'] ||= '100'

      puts 'Preparing...'
      sh 'mruby/build/host/bin/mitamae local benchmark/delete.rb'

      puts "\n\n=== file creation ==="
      sh 'time mruby/build/host/bin/mitamae local benchmark/create.rb'

      puts "\n\n=== no operation ==="
      sh 'time mruby/build/host/bin/mitamae local benchmark/create.rb'

      puts "\n\n=== file deletion ==="
      sh 'time mruby/build/host/bin/mitamae local benchmark/delete.rb'
    end
  end
end

desc "run all tests"
Rake::Task['test'].clear
task :test => ["test:mtest", "test:bintest"]

desc "cleanup"
task :clean do
  sh "rake deep_clean"
end

namespace :release do
  desc "cross compile for release"
  task :build do
    sh 'docker-compose run -e BUILD_TARGET=all compile'

    Dir.chdir(__dir__) do
      FileUtils.mkdir_p('mitamae-build')

      {
        'i386-apple-darwin14'   => 'mitamae-i386-darwin',
        'i686-pc-linux-gnu'     => 'mitamae-i686-linux',
        'x86_64-apple-darwin14' => 'mitamae-x86_64-darwin',
        'x86_64-pc-linux-gnu'   => 'mitamae-x86_64-linux',
      }.each do |build, bin|
        FileUtils.cp(
          "mruby/build/#{build}/bin/mitamae",
          "mitamae-build/#{bin}",
        )
      end
    end
  end

  namespace :build do
    %w[
      linux-x86_64
      linux-i686
      darwin-x86_64
      darwin-i386
    ].each do |target|
      desc "Build for #{target}"
      task target do
        sh "docker-compose run -e BUILD_TARGET=#{target} compile"
      end
    end
  end

  desc "compress binaries in mitamae-build"
  task :compress do
    Dir.chdir(File.expand_path('./mitamae-build', __dir__)) do
      Dir.glob('mitamae-*-darwin').each do |path|
        sh "tar zcvf #{path}.tar.gz #{path}"
      end

      Dir.glob('mitamae-*-linux').each do |path|
        sh "tar zcvf #{path}.tar.gz #{path}"
      end
    end
  end

  desc "fetch ghr binary"
  task :ghr do
    Dir.chdir(__dir__) do
      next if File.exist?('ghr')

      zip_url =
        if `uname` =~ /\ADarwin/
          'https://github.com/tcnksm/ghr/releases/download/v0.4.0/ghr_v0.4.0_darwin_386.zip'
        else
          'https://github.com/tcnksm/ghr/releases/download/v0.4.0/ghr_v0.4.0_linux_386.zip'
        end
      sh "curl -L #{zip_url} > ghr.zip"
      sh "unzip ghr.zip"
    end
  end

  desc "upload compiled binary to GitHub"
  task upload: :ghr do
    unless ENV.has_key?('GITHUB_TOKEN')
      puts 'Usage: rake release GITHUB_TOKEN="..."'
      puts
      abort 'Specify GITHUB_TOKEN generated from https://github.com/settings/tokens.'
    end

    Dir.chdir(__dir__) do
      require_relative './mrblib/mitamae/version'
      sh "./ghr -u k0kubun v#{MItamae::VERSION} mitamae-build"
    end
  end
end

desc "release mitamae with current revision"
task release: ['release:build', 'release:compress', 'release:upload']
