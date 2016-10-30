package 'dstat' do
  action :install
end

package 'sl' do
  version '3.03-17build1'
end

package 'resolvconf' do
  action :remove
end
