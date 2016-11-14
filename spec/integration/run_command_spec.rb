require 'spec_helper'

describe 'user resource' do
  it 'is appliable' do
    expect { apply_recipe('run_command') }.to_not raise_error
  end
end
