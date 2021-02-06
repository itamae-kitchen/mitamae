require 'spec_helper'

describe 'service resource' do
  it 'is appliable' do
    expect { apply_recipe('service') }.to_not raise_error
  end
end
