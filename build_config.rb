def gem_config(conf)
  #conf.gembox 'default'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.gem mgem: 'mruby-file-stat',      checksum_hash: '2d3ea9b5d59d2b41133228a71c110b75cb30a31e'
  conf.gem mgem: 'mruby-hashie',         checksum_hash: 'bfdbb8aebc8786bc9e88469dae87a8dfe8ec4300'
  conf.gem mgem: 'mruby-io',             checksum_hash: '6836f424c5ff95d0114a426010b22254804bc9a3'
  conf.gem mgem: 'mruby-open3',          checksum_hash: 'b7480b6300a81d0e5fac469a36a383518e3dfc78'
  conf.gem mgem: 'mruby-shellwords',     checksum_hash: '2a284d99b2121615e43d6accdb0e4cde1868a0d8'
  conf.gem mgem: 'mruby-specinfra',      checksum_hash: '22a54436fe53afd310ad4473d28edd03dd960a24'
  conf.gem github: 'k0kubun/mruby-erb',  checksum_hash: '978257e478633542c440c9248e8cdf33c5ad2074'
  conf.gem github: 'eagletmt/mruby-etc', checksum_hash: 'v0.1.0'
  conf.gem github: 'take-cheeze/mruby-socket', checksum_hash: '7b4978b639e9b73296f5ced39dbcb722bf42cd0d' # https://github.com/iij/mruby-socket/issues/36
end

def debug_config(conf)
  conf.instance_eval do
    # In `enable_debug`, use this for release build too.
    # Allow showing backtrace and prevent "fptr_finalize failed" error in mruby-io.
    @mrbc.compile_options += ' -g'
  end
end

build_targets = ENV.fetch('BUILD_TARGET', '').split(',')
if build_targets == ['all']
  build_targets = %w[
    linux-x86_64
    linux-i686
    darwin-x86_64
    darwin-i386
  ]
end

MRuby::Build.new do |conf|
  toolchain :gcc

  #conf.enable_bintest
  #conf.enable_debug
  #conf.enable_test

  debug_config(conf)
  gem_config(conf)
end

if build_targets.include?('linux-x86_64')
  MRuby::Build.new('x86_64-pc-linux-gnu') do |conf|
    toolchain :gcc

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-i686')
  MRuby::CrossBuild.new('i686-pc-linux-gnu') do |conf|
    toolchain :gcc

    [conf.cc, conf.cxx, conf.linker].each do |cc|
      cc.flags << "-m32"
    end

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-x86_64')
  MRuby::CrossBuild.new('x86_64-apple-darwin14') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'x86_64-apple-darwin14-clang'
    end
    conf.cxx.command      = 'x86_64-apple-darwin14-clang++'
    conf.archiver.command = 'x86_64-apple-darwin14-ar'

    conf.build_target     = 'x86_64-pc-linux-gnu'
    conf.host_target      = 'x86_64-apple-darwin14'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-i386')
  MRuby::CrossBuild.new('i386-apple-darwin14') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'i386-apple-darwin14-clang'
    end
    conf.cxx.command      = 'i386-apple-darwin14-clang++'
    conf.archiver.command = 'i386-apple-darwin14-ar'

    conf.build_target     = 'i386-pc-linux-gnu'
    conf.host_target      = 'i386-apple-darwin14'

    debug_config(conf)
    gem_config(conf)
  end
end
