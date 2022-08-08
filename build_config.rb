def gem_config(conf)
  conf.gem File.expand_path(File.dirname(__FILE__))
end

def debug_config(conf)
  conf.instance_eval do
    # In `enable_debug`, use this for release build too.
    # Allow showing backtrace and prevent "fptr_finalize failed" error in mruby-io.
    @mrbc.compile_options += ' -g'
  end
end

def download_macos_sdk(path)
  version = '11.3'
  system('wget', "https://github.com/phracker/MacOSX-SDKs/releases/download/#{version}/MacOSX#{version}.sdk.tar.xz", exception: true)
  system('tar', 'xf', "MacOSX#{version}.sdk.tar.xz", exception: true)
  system('rm', "MacOSX#{version}.sdk.tar.xz", exception: true)
  system('mv', "MacOSX#{version}.sdk", path, exception: true)
end

macos_sdk = File.expand_path('./MacOSX.sdk', __dir__)
build_targets = ENV.fetch('BUILD_TARGET', '').split(',')

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
      cc.command = 'zig cc -target x86_64-linux-musl'
    end
    conf.archiver.command = 'zig ar'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-i386')
  MRuby::CrossBuild.new('linux-i386') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'zig cc -target i386-linux-musl'
    end
    conf.archiver.command = 'zig ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.host_target = 'i386-pc-linux-gnu'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-armhf')
  MRuby::CrossBuild.new('linux-armhf') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'zig cc -target arm-linux-musleabihf'
    end
    conf.archiver.command = 'zig ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.host_target = 'arm-linux-musleabihf'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-aarch64')
  MRuby::CrossBuild.new('linux-aarch64') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'zig cc -target aarch64-linux-musl'
    end
    conf.archiver.command = 'zig ar'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.host_target = 'aarch64-linux-musl'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-x86_64')
  MRuby::CrossBuild.new('darwin-x86_64') do |conf|
    toolchain :gcc

    unless Dir.exist?(macos_sdk)
      download_macos_sdk(macos_sdk)
    end

    conf.cc.command = "zig cc -target x86_64-macos -mmacosx-version-min=10.14 -isysroot #{macos_sdk.shellescape} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks"
    conf.linker.command = "zig cc -target x86_64-macos -mmacosx-version-min=10.4 --sysroot #{macos_sdk.shellescape} -F/System/Library/Frameworks -L/usr/lib"
    conf.archiver.command = 'zig ar'
    ENV['RANLIB'] ||= 'zig ranlib'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.host_target = 'x86_64-darwin'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-aarch64')
  MRuby::CrossBuild.new('darwin-aarch64') do |conf|
    toolchain :gcc

    unless Dir.exist?(macos_sdk)
      download_macos_sdk(macos_sdk)
    end

    conf.cc.command = "zig cc -target aarch64-macos -mmacosx-version-min=11.1 -isysroot #{macos_sdk.shellescape} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks"
    conf.linker.command = "zig cc -target aarch64-macos -mmacosx-version-min=11.1 --sysroot #{macos_sdk.shellescape} -F/System/Library/Frameworks -L/usr/lib"
    conf.archiver.command = 'zig ar'
    ENV['RANLIB'] ||= 'zig ranlib'

    # To configure: mrbgems/mruby-yaml, k0kubun/mruby-onig-regexp
    conf.host_target = 'aarch64-darwin'

    debug_config(conf)
    gem_config(conf)
  end
end
