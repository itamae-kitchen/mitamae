require 'fileutils'

APP_NAME=ENV["APP_NAME"] || "mitamae"
APP_ROOT=ENV["APP_ROOT"] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

desc "compile binary"
task :compile => [:all] do
  %W(#{mruby_root}/build/x86_64-pc-linux-gnu/bin/#{APP_NAME} #{mruby_root}/build/i686-pc-linux-gnu/#{APP_NAME}").each do |bin|
    sh "strip --strip-unneeded #{bin}" if File.exist?(bin)
  end
end

desc "run mruby & unit tests"
# only build mtest for host
task 'test:mtest' => 'test:compile' do
  # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
  # we need to make sure the tests are built relative from mruby_root
  MRuby.each_target do |target|
    # only run unit tests here
    target.enable_bintest = false
    run_test if target.test_enabled?
  end
end

ENV['DOCKER_CONTAINER'] ||= 'mitamae-spec'
desc 'run spec container'
task 'test:compile' do
  Dir.chdir(__dir__) do
    sh 'docker-compose run -e BUILD_TARGET=linux-x86_64 compile'
  end
end

desc 'run bundle install'
task 'test:bundle_install' do
  Dir.chdir(__dir__) do
    sh 'bundle check || bundle install -j4'
  end
end

desc 'run serverspec'
task 'test:serverspec' => 'test:bundle_install' do
  Dir.chdir(__dir__) do
    sh 'bundle exec rspec'
  end
end

desc 'run integration tests'
task 'test:integration' => 'test:serverspec'

desc 'Benchmark recipe execution'
task 'test:benchmark' => 'test:compile' do
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

desc "run all tests"
if Object.const_defined?(:MiniRake)
  MiniRake::Task::TASKS.delete('test')
else
  Rake::Task['test'].clear
end
task :test => ["test:mtest", "test:bintest"]

desc "cleanup"
task :clean do
  sh "rake deep_clean"
end

desc "cross compile for release"
task 'release:build' do
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

%w[
  linux-x86_64
  linux-i686
  darwin-x86_64
  darwin-i386
].each do |target|
  desc "Build for #{target}"
  task "release:build:#{target}" do
    sh "docker-compose run -e BUILD_TARGET=#{target} compile"
  end
end

desc "compress binaries in mitamae-build"
task 'release:compress' do
  Dir.chdir(File.expand_path('./mitamae-build', __dir__)) do
    Dir.glob('mitamae-*-darwin').each do |path|
      sh "tar zcvf #{path}.tar.gz #{path}"
    end

    Dir.glob('mitamae-*-linux').each do |path|
      sh "tar zcvf #{path}.tar.gz #{path}"
    end
  end
end

desc "download ghr binary"
task 'download:ghr' do
  Dir.chdir(__dir__) do
    next if File.exist?('ghr')

    version = "v0.5.4"
    zip_url =
      if `uname` =~ /\ADarwin/
        "https://github.com/tcnksm/ghr/releases/download/#{version}/ghr_#{version}_darwin_amd64.zip"
      else
        "https://github.com/tcnksm/ghr/releases/download/#{version}/ghr_#{version}_linux_amd64.zip"
      end
    sh "curl -L #{zip_url} > ghr.zip"
    sh "unzip ghr.zip"
  end
end

desc "upload compiled binary to GitHub"
task 'release:upload' => 'download:ghr' do
  unless ENV.has_key?('GITHUB_TOKEN')
    puts 'Usage: rake release GITHUB_TOKEN="..."'
    puts
    abort 'Specify GITHUB_TOKEN generated from https://github.com/settings/tokens.'
  end

  Dir.chdir(__dir__) do
    require_relative './mrblib/mitamae/version'
    sh "./ghr -u itamae-kitchen v#{MItamae::VERSION} mitamae-build"
  end
end

desc "release mitamae with current revision"
task release: ['release:build', 'release:compress', 'release:upload']
