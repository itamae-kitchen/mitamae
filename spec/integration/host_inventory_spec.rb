require 'spec_helper'

describe 'host_inventory' do
  before(:all) do
    apply_recipe('host_inventory')
  end

  {
    memory: /"swap"/,
    #ec2: //,
    hostname: /\A\w{12}\z/,
    #domain: //,
    fqdn: /\A\w{12}\z/,
    platform: /\Aubuntu\z/,
    platform_version: /\A14.04\z/,
    filesystem: /"kb_size"/,
    cpu: /"cpu_family"/,
    virtualization: /\A{}\z/,
    kernel: /"name"=>"Linux"/,
    block_device: /\A{}\z/,
    user: /"name"=>"root", "uid"=>"0"/,
    group: /"name"=>"root", "gid"=>"0"/,
  }.each do |key, expected|
    describe file("/tmp/host_inventory_#{key}") do
      it { should be_file }
      its(:content) { should match(expected) }
    end
  end
end
