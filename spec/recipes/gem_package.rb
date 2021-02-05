# `gem update --system` says:
#
# ERROR:  While executing gem ... (RuntimeError)
#     gem update --system is disabled on Debian, because it will overwrite the content of the rubygems Debian package, and might break your Debian system in subtle ways. The Debian-supported way to update rubygems is through apt-get, using Debian official repositories.
# If you really know what you are doing, you can still update rubygems by setting the REALLY_GEM_UPDATE_SYSTEM environment variable, but please remember that this is completely unsupported by Debian.

execute 'env REALLY_GEM_UPDATE_SYSTEM=1 gem update --no-doc --system 2.7.3' do
  not_if { run_command('gem --version').stdout.chomp == '2.7.3' }
end

gem_package 'tzinfo' do
  version '1.1.0'
end

gem_package 'tzinfo' do
  version '1.2.2'
end

gem_package 'rake' do
  version '12.0.0' # rake >= 12.3.0 doesn't support Ruby 1.9.3 which is used in k0kubun/mitamae-spec container
  options ['--no-document']
end

# default gem
gem_package 'bundler' do
  version '1.16.0'
  notifies :create, 'file[/tmp/bundler_is_installed]'
end

file '/tmp/bundler_is_installed' do
  action :nothing
end

gem_package 'unindent' do
  version '0.9'
end

gem_package 'unindent' do
  version '1.0'
end

gem_package 'unindent' do
  action :uninstall
  version '1.0'
end

gem_package 'perf' do
  version '0.1.2'
end

gem_package 'perf' do
  version '0.1.1'
end

gem_package 'perf' do
  action :uninstall
end
