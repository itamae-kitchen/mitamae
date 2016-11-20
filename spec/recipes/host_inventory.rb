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
