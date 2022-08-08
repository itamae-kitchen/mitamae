require 'fileutils'
require 'shellwords'

MRUBY_VERSION = '3.0.0'

file :mruby do
  if RUBY_PLATFORM.match(/solaris/)
    sh "git clone --branch=#{MRUBY_VERSION} https://github.com/mruby/mruby"
    patch = 'gpatch'
  else
    sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz -s -o - | tar zxf -"
    FileUtils.mv("mruby-#{MRUBY_VERSION}", 'mruby')
    patch = 'patch'
  end

  # Patch: https://github.com/mruby/mruby/pull/5318
  if MRUBY_VERSION == '3.0.0'
    IO.popen([patch, '-p0'], 'w') do |io|
      io.write(<<-'EOS')
--- mruby/lib/mruby/build.rb  2021-03-05 00:07:35.000000000 -0800
+++ mruby/lib/mruby/build.rb  2021-03-05 12:25:15.159190950 -0800
@@ -320,12 +320,16 @@
       return @mrbcfile if @mrbcfile

       gem_name = "mruby-bin-mrbc"
-      gem = @gems[gem_name]
-      gem ||= (host = MRuby.targets["host"]) && host.gems[gem_name]
-      unless gem
-        fail "external mrbc or mruby-bin-mrbc gem in current('#{@name}') or 'host' build is required"
+      if (gem = @gems[gem_name])
+        @mrbcfile = exefile("#{gem.build.build_dir}/bin/mrbc")
+      elsif !host? && (host = MRuby.targets["host"])
+        if (gem = host.gems[gem_name])
+          @mrbcfile = exefile("#{gem.build.build_dir}/bin/mrbc")
+        elsif host.mrbcfile_external?
+          @mrbcfile = host.mrbcfile
+        end
       end
-      @mrbcfile = exefile("#{gem.build.build_dir}/bin/mrbc")
+      @mrbcfile || fail("external mrbc or mruby-bin-mrbc gem in current('#{@name}') or 'host' build is required")
     end

     def mrbcfile=(path)
      EOS
    end
  end
end

CROSS_TARGETS = %w[
  linux-x86_64
  linux-i386
  linux-armhf
  linux-aarch64
  darwin-x86_64
  darwin-aarch64
]

STRIP_TARGETS = %w[
  linux-x86_64
  linux-i386
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
task 'release:build' => CROSS_TARGETS.map { |target| "release:build:#{target}" }

CROSS_TARGETS.each do |target|
  desc "Build for #{target}"
  task "release:build:#{target}" do
    Dir.chdir(__dir__) do
      # Workaround: Running `rake compile` twice breaks mattn/mruby-onig-regexp
      FileUtils.rm_rf('mruby/build')

      sh "rake compile BUILD_TARGET=#{target.shellescape}"

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
