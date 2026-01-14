MACOS_SDK= File.expand_path('./MacOSX.sdk', __dir__)
MACOS_SDK_VER = "11.3"

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
  system('wget', "https://github.com/phracker/MacOSX-SDKs/releases/download/#{MACOS_SDK_VER}/MacOSX#{MACOS_SDK_VER}.sdk.tar.xz", exception: true)
  system('tar', 'xf', "MacOSX#{MACOS_SDK_VER}.sdk.tar.xz", exception: true)
  system('rm', "MacOSX#{MACOS_SDK_VER}.sdk.tar.xz", exception: true)
  system('mv', "MacOSX#{MACOS_SDK_VER}.sdk", path, exception: true)
end

TRIPLETS = {
  'linux-x86_64' => 'x86_64-linux-musl',
  'linux-i386' => 'x86-linux-musl',
  'linux-armhf' => 'arm-linux-musleabihf',
  'linux-aarch64' => 'aarch64-linux-musl',
  'linux-ppc64le' => 'powerpc64le-linux-musl',
  'linux-s390x' => 's390x-linux-musl',
  'darwin-x86_64' => 'x86_64-macos-none',
  'darwin-aarch64' => 'aarch64-macos-none',
  'freebsd-x86_64' => 'x86_64-freebsd-none',
  'freebsd-aarch64' => 'aarch64-freebsd-none',
  'openbsd-x86_64' => 'x86_64-openbsd-none',
  'openbsd-aarch64' => 'aarch64-openbsd-none'
}.freeze


# mruby's build system always requires to run host build for mrbc
MRuby::Build.new do |conf|
  toolchain :gcc

  #conf.enable_bintest
  #conf.enable_debug
  #conf.enable_test

  debug_config(conf)
  gem_config(conf)
end

build_targets = ENV.fetch('BUILD_TARGET', '').split(',')
CROSS_TARGETS.each do |target|
  next unless build_targets.include?(target)

  MRuby::CrossBuild.new(target) do |conf|
    toolchain :gcc

    conf.host_target = TRIPLETS[target]

    [conf.cc, conf.linker].each do |cc|
      cc.command = "zig cc -target #{TRIPLETS[target]}"
    end
    conf.archiver.command = 'zig ar'
    ENV['RANLIB'] ||= 'zig ranlib' unless target.include?('linux')

    if target.include?('darwin')
      macosx_min_ver = target.include?('aarch64') ? '11.1' : '10.14'
      unless Dir.exist?(MACOS_SDK)
        download_macos_sdk(MACOS_SDK)
      end

      conf.cc.command += " -mmacosx-version-min=#{macosx_min_ver} -isysroot #{MACOS_SDK.shellescape}"
      conf.cc.command += " -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks"
      conf.linker.command += " -mmacosx-version-min=#{macosx_min_ver} --sysroot #{MACOS_SDK.shellescape}"
      conf.linker.command += " -F/System/Library/Frameworks -L/usr/lib"
    else
    end

    debug_config(conf)
    gem_config(conf)
  end
end
