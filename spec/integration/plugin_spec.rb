require 'spec_helper'

describe 'plugins' do
  let(:__file__) { file('/tmp/mitamae-plugin-resource-test-file').content }

  it 'runs plugins with cwd relative to ./plugins' do
    apply_recipe('plugins', cwd: '/')
    expect(__file__).to eq('/plugins/mitamae-plugin-resource-test/mrblib/resource_executor/test.rb')
  end

  it 'runs plugins with --plugins regardless of cwd' do
    apply_recipe('plugins', cwd: '/tmp', options: ['--plugins=/plugins'])
    expect(__file__).to eq('/plugins/mitamae-plugin-resource-test/mrblib/resource_executor/test.rb')
  end
end
