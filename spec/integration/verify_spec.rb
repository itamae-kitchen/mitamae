require 'spec_helper'

describe 'verify attribute' do
  it 'succeeds to apply when verified' do
    expect { apply_recipe('verified') }.to_not raise_error
  end

  it 'failes to apply when not verified' do
    expect { apply_recipe('not_verified') }.to raise_error(RuntimeError)
  end
end
