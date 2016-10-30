package 'ruby'

gem_package 'tzinfo' do
  version '1.1.0'
end

gem_package 'tzinfo' do
  version '1.2.2'
end

gem_package 'bundler' do
  options ['--no-ri', '--no-rdoc']
end

gem_package 'karabiner' do
  version '0.3.1'
end

gem_package 'karabiner' do
  version '0.4.0'
end

gem_package 'karabiner' do
  action :uninstall
  version '0.4.0'
end

gem_package 'rack-user_agent' do
  version '0.5.2'
end

gem_package 'rack-user_agent' do
  action :uninstall
end
