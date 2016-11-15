require 'spec_helper'

describe 'remote_file resource' do
  before(:all) do
    apply_recipe('remote_file')
  end

  %w!/tmp/remote_file /tmp/remote_file_auto!.each do |f|
    describe file(f) do
      it { should be_file }
      its(:content) { should match(/Hello Itamae/) }
    end
  end
end
