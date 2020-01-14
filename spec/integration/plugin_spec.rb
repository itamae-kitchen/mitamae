require 'spec_helper'

describe 'plugins' do
  it 'runs plugins with cwd relative to ./plugins' do
    apply_recipe('plugins', cwd: '/')
  end

  it 'runs plugins with --plugins regardless of cwd' do
    apply_recipe('plugins', cwd: '/tmp', options: ['--plugins=/plugins'])
  end
end
