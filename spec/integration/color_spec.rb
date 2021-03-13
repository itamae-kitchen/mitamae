require 'spec_helper'

describe 'no-color' do
  it 'is appliable' do
    expect { apply_recipe('color', options: %w[--no-color], redirect: { out: "/tmp/color-result-file" }) }.to_not raise_error
  end
end
