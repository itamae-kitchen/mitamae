require 'fileutils'
require 'shellwords'

MRUBY_VERSION = '2.1.0'

file :mruby do
  sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz -s -o - | tar zxf -"
  FileUtils.mv("mruby-#{MRUBY_VERSION}", "mruby")
end

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
      'arm-linux-gnueabihf'   => 'mitamae-armhf-linux',
    }.each do |build, bin|
      sh "cp mruby/build/#{build.shellescape}/bin/mitamae mitamae-build/#{bin.shellescape}"
    end
  end
end

%w[
  linux-x86_64
  linux-i686
  linux-armhf
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
    Dir.glob('mitamae-*').each do |path|
      sh "tar zcvf #{path}.tar.gz #{path}"
    end
  end
end
