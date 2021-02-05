package 'dstat' do
  action :install
end

package 'sl' do
  version '5.02-1'
end

package 'resolvconf' do
  action :remove
end
