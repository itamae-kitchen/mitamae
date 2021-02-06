require 'spec_helper'
require_relative '../mrblib/mitamae/version'

describe MItamae::VERSION do
  it 'is the latest version in CHANGELOG.md' do
    changelog = File.read(File.expand_path('../CHANGELOG.md', __dir__))
    versions = changelog.scan(/^## v\d+\.\d+\.\d+$/).map { |line| line.sub(/\A## v/, '') }
    expect(versions).not_to be_empty
    expect(MItamae::VERSION).to eq(versions.first)
  end
end
