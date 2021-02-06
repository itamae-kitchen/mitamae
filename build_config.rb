def gem_config(conf)
  #conf.gembox 'default'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.gem mgem: 'mruby-file-stat',             checksum_hash: '66cf135ff9642d96a6127a79b307f6314e606deb'
  conf.gem mgem: 'mruby-hashie',                checksum_hash: 'c69255a94debcd641f2087b569f5625509bde698'
  conf.gem mgem: 'mruby-open3',                 checksum_hash: 'b2dba93fdbd60dcff8aa20b6c56014ac89d267ad'
  conf.gem mgem: 'mruby-shellwords',            checksum_hash: '2a284d99b2121615e43d6accdb0e4cde1868a0d8'
  conf.gem mgem: 'mruby-specinfra',             checksum_hash: '69fe4306e2b004baa9dd54d4fbf9262988ce7d03'
  conf.gem github: 'k0kubun/mruby-erb',         checksum_hash: '978257e478633542c440c9248e8cdf33c5ad2074'
  conf.gem github: 'k0kubun/mruby-tempfile',    checksum_hash: 'e628c8fcb4bca3f3456640a8b56d1ae98c594e24'
  conf.gem github: 'mrbgems/mruby-yaml',        checksum_hash: '0606652a6e99d902cd3101cf2d757a7c0c37a7fd'
  conf.gem github: 'eagletmt/mruby-etc',        checksum_hash: 'v0.1.0'
end

def debug_config(conf)
  conf.instance_eval do
    # In `enable_debug`, use this for release build too.
    # Allow showing backtrace and prevent "fptr_finalize failed" error in mruby-io.
    @mrbc.compile_options += ' -g'
  end
end

build_targets = ENV.fetch('BUILD_TARGET', '').split(',')
if ENV.key?('CROSS_ROOT') && ENV.key?('CROSS_TRIPLE') # dockcross
  # Unset dockcross env to make mrbgem's configure work for host build
  dockcross_ar  = ENV.delete('AR')
  dockcross_cc  = ENV.delete('CC')
  dockcross_cxx = ENV.delete('CXX')
  %w[AS CPP LD FD].each do |env|
    ENV.delete(env)
  end
end

# mruby's build system always requires to run host build for mrbc
MRuby::Build.new do |conf|
  toolchain :gcc

  #conf.enable_bintest
  #conf.enable_debug
  #conf.enable_test

  debug_config(conf)
  gem_config(conf)
end

if build_targets.include?('linux-x86_64')
  MRuby::Build.new('linux-x86_64') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'musl-gcc'
      cc.flags += %w[-static -Os]
    end

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-i686')
  MRuby::CrossBuild.new('linux-i686') do |conf|
    toolchain :gcc

    [conf.cc, conf.cxx, conf.linker].each do |cc|
      cc.flags << '-m32'
    end

    # To configure: k0kubun/mruby-onig-regexp
    conf.host_target = 'i686-pc-linux-gnu'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-armhf')
  MRuby::CrossBuild.new('linux-armhf') do |conf|
    toolchain :gcc

    # dockcross/linux-armhf
    conf.cc.command       = dockcross_cc
    conf.cxx.command      = dockcross_cxx
    conf.linker.command   = dockcross_cxx
    conf.archiver.command = dockcross_ar

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.build_target = 'x86_64-pc-linux-gnu'
    conf.host_target  = 'arm-linux-gnueabihf'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-aarch64')
  MRuby::CrossBuild.new('linux-aarch64') do |conf|
    toolchain :gcc

    # dockcross/linux-aarch64
    conf.cc.command       = dockcross_cc
    conf.cxx.command      = dockcross_cxx
    conf.linker.command   = dockcross_cxx
    conf.archiver.command = dockcross_ar

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.build_target = 'x86_64-pc-linux-gnu'
    conf.host_target  = 'aarch64-linux-gnu'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-x86_64')
  MRuby::CrossBuild.new('darwin-x86_64') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'x86_64-apple-darwin20.2-clang'
    end
    conf.cxx.command      = 'x86_64-apple-darwin20.2-clang++'
    conf.archiver.command = 'x86_64-apple-darwin20.2-ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.build_target     = 'x86_64-pc-linux-gnu'
    conf.host_target      = 'x86_64-apple-darwin20.2'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-i386')
  MRuby::CrossBuild.new('darwin-i386') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'i386-apple-darwin20.2-clang'
    end
    conf.cxx.command      = 'i386-apple-darwin20.2-clang++'
    conf.archiver.command = 'i386-apple-darwin20.2-ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.build_target     = 'i386-pc-linux-gnu'
    conf.host_target      = 'i386-apple-darwin20.2'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-aarch64')
  MRuby::CrossBuild.new('darwin-aarch64') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'aarch64-apple-darwin20.2-clang'
    end
    conf.cxx.command      = 'aarch64-apple-darwin20.2-clang++'
    conf.archiver.command = 'aarch64-apple-darwin20.2-ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.build_target     = 'aarch64-pc-linux-gnu'
    conf.host_target      = 'aarch64-apple-darwin20.2'

    debug_config(conf)
    gem_config(conf)
  end
end
