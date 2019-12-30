require 'spec_helper'

describe 'mruby 2.1.0 crash' do
  it 'applies mruby_crash1' do
    apply_recipe('mruby_crash1', options: ['--log-level=debug'])
  end

  it 'applies mruby_crash2' do
    apply_recipe('mruby_crash2', options: ['--log-level=debug'])
  end
end
