require 'fileutils'
require 'shellwords'

MRUBY_VERSION = '2.0.1'

file :mruby do
  if RUBY_PLATFORM.match(/solaris/)
    sh "git clone --branch=#{MRUBY_VERSION} https://github.com/mruby/mruby"
  else
    sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz -s -o - | tar zxf -"
    FileUtils.mv("mruby-#{MRUBY_VERSION}", 'mruby')
  end
end

MRUBY_CLI_TARGETS = %w[
  linux-x86_64
  linux-i686
  linux-armhf
  darwin-x86_64
  darwin-i386
]
DOCKCROSS_TARGETS = %w[
  linux-arm64
]

STRIP_TARGETS = %w[
  linux-x86_64
  linux-i686
]

APP_NAME=ENV['APP_NAME'] || 'mitamae'
APP_ROOT=ENV['APP_ROOT'] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV['MRUBY_ROOT'] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV['MRUBY_CONFIG'] || 'build_config.rb')
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

desc 'compile binary'
task :compile => [:all] do
  STRIP_TARGETS.each do |target|
    bin = "#{mruby_root}/build/#{target}/bin/#{APP_NAME}"
    sh "strip --strip-unneeded #{bin}" if File.exist?(bin)
  end
end

desc 'run mruby & unit tests'
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

desc 'run all tests'
if Object.const_defined?(:MiniRake)
  MiniRake::Task::TASKS.delete('test')
else
  Rake::Task['test'].clear
end
task :test => ['test:mtest', 'test:bintest']

desc 'cleanup'
task :clean do
  sh 'rake deep_clean'
end

desc 'cross compile for release'
task 'release:build' => (MRUBY_CLI_TARGETS + DOCKCROSS_TARGETS).map { |target| "release:build:#{target}" }

(MRUBY_CLI_TARGETS + DOCKCROSS_TARGETS).each do |target|
  desc "Build for #{target}"
  task "release:build:#{target}" do
    if DOCKCROSS_TARGETS.include?(target)
      sh 'docker-compose run compile' # build host/bin/mrbc
      sh [
        'docker', 'run', '--rm', '-e', "BUILD_TARGET=#{target}", '-e', 'BUILD_HOST=0',
        '-v', "#{File.expand_path(__dir__)}:/home/mruby/code", '-w', '/home/mruby/code',
        "k0kubun/mitamae-dockcross:#{target}", 'rake', 'compile',
      ].shelljoin
    else
      sh "docker-compose run -e BUILD_TARGET=#{target} compile"
    end

    Dir.chdir(__dir__) do
      FileUtils.mkdir_p('mitamae-build')
      os, arch = target.split('-', 2)
      sh "cp mruby/build/#{target.shellescape}/bin/mitamae mitamae-build/mitamae-#{arch.shellescape}-#{os.shellescape}"
    end
  end
end

desc 'compress binaries in mitamae-build'
task 'release:compress' do
  Dir.chdir(File.expand_path('./mitamae-build', __dir__)) do
    Dir.glob('mitamae-*').each do |path|
      sh "tar zcvf #{path}.tar.gz #{path}"
    end
  end
end
