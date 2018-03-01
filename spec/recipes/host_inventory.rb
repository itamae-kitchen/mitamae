keys = [
  :memory,
  #:ec2,
  :hostname,
  #:domain,
  :fqdn,
  :platform,
  :platform_version,
  :filesystem,
  :cpu,
  :virtualization,
  :kernel,
  :block_device,
  :user,
  :group,
].each do |key|
  file "/tmp/host_inventory_#{key}" do
    content node[key].to_s
  end
end

file '/tmp/host_inventory_cpu_total' do
  content node[:cpu][:total]
end

# Just testing that this doesn't raise an error
file '/tmp/host_inventory_ec2' do
  content node[:ec2][:instance_type].inspect
end
