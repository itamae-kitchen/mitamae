require 'spec_helper'

describe 'local_ruby_block resource' do
  it 'is appliable' do
    expect { apply_recipe('local_ruby_block') }.to_not raise_error
  end
end
