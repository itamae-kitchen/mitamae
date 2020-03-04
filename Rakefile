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
  darwin-x86_64
  darwin-i386
]

DOCKCROSS_TARGETS = %w[
  linux-x86_64
  linux-i686
  linux-armhf
  linux-aarch64
]
DOCKCROSS_ALIASES = {
  'linux-aarch64' => 'linux-arm64',
}

STRIP_TARGETS = %w[
  linux-x86_64
  linux-i686
]

# avoid redefining constants in mruby Rakefile
mruby_root = File.expand_path(ENV['MRUBY_ROOT'] || "#{Dir.pwd}/mruby")
mruby_config = File.expand_path(ENV['MRUBY_CONFIG'] || 'build_config.rb')
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

desc 'run serverspec'
task 'test:integration' do
  Dir.chdir(__dir__) do
    sh 'bundle check || bundle install -j4'
    sh 'bundle exec rspec'
  end
end

desc 'compile binary'
task compile: :all

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
      sh [
        'docker', 'run', '--rm', '-e', "BUILD_TARGET=#{target}",
        '-v', "#{File.expand_path(__dir__)}:/home/mruby/code", '-w', '/home/mruby/code',
        "k0kubun/mitamae-dockcross:#{DOCKCROSS_ALIASES.fetch(target, target)}", 'rake', 'compile',
      ].shelljoin
    else
      sh "docker-compose run -e BUILD_TARGET=#{target} compile"
    end

    Dir.chdir(__dir__) do
      FileUtils.mkdir_p('mitamae-build')
      os, arch = target.split('-', 2)
      bin = "mitamae-build/mitamae-#{arch}-#{os}"
      sh "cp mruby/build/#{target.shellescape}/bin/mitamae #{bin.shellescape}"

      if STRIP_TARGETS.include?(target)
        sh "strip --strip-unneeded #{bin.shellescape}"
      end
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
