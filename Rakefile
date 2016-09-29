require 'fileutils'

file :mruby do
  # Using master to apply https://github.com/mruby/mruby/pull/3192
  revision = '2d335daeeb1d50402041041c7a3531674a2e735a'
  sh "git clone https://github.com/mruby/mruby && git -C mruby checkout #{revision}"

  #sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/1.2.0.tar.gz -s -o - | tar zxf -"
  #FileUtils.mv("mruby-1.2.0", "mruby")
end

APP_NAME=ENV["APP_NAME"] || "itamae"
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

  desc "run integration tests"
  task :bintest => :compile do
    MRuby.each_target do |target|
      clean_env(%w(MRUBY_ROOT MRUBY_CONFIG)) do
        run_bintest if target.bintest_enabled?
      end
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
    sh "docker-compose run compile"

    Dir.chdir(__dir__) do
      FileUtils.mkdir_p('itamae-build')

      {
        'i386-apple-darwin14'   => 'itamae-i386-darwin',
        'i686-pc-linux-gnu'     => 'itamae-i686-linux',
        'x86_64-apple-darwin14' => 'itamae-x86_64-darwin',
        'x86_64-pc-linux-gnu'   => 'itamae-x86_64-linux',
      }.each do |build, bin|
        system('pwd')
        FileUtils.cp(
          "mruby/build/#{build}/bin/itamae",
          "itamae-build/#{bin}",
        )
      end
    end
  end

  desc "compress binaries in itamae-build"
  task :compress do
    Dir.chdir(__dir__) do
      Dir.glob('itamae-build/itamae-*-{darwin,linux}').each do |path|
        Dir.chdir('itamae-build') do
          file = File.basename(path)
          sh "zip #{file}.zip #{file}"
        end
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
      require_relative './mrblib/itamae/version'
      sh "./ghr -u k0kubun v#{Itamae::VERSION} itamae-build"
    end
  end
end

desc "release itamae-mruby with current revision"
task release: ['release:build', 'release:compress', 'release:upload']
