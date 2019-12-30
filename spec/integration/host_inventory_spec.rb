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
    virtualization: /\A{"system"=>"docker"}\z/,
    kernel: /"name"=>"Linux"/,
    block_device: /\A{}\z/,
    user: /"root"=>{[^{}]*"uid"=>"0", /,
  }.each do |key, expected|
    describe file("/tmp/host_inventory_#{key}") do
      it { should be_file }
      its(:content) { should match(expected) }
    end
  end

  describe file('/tmp/host_inventory_group') do
    it { should be_file }
    its(:content) { should match(/"name"=>"root"/) }
    its(:content) { should match(/"gid"=>"0"/) }
  end

  describe file('/tmp/host_inventory_cpu_total') do
    it { should be_file }
    its(:content) { should match(/\A\d+\z/) }
  end

  describe file('/tmp/host_inventory_ec2') do
    it { should be_file }
  end
end
