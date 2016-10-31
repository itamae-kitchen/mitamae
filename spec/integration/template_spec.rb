require 'spec_helper'

%w!/tmp/template /tmp/template_auto!.each do |f|
  describe file(f) do
    it { should be_file }
    # its(:content) { should match(/Hello/) }
    its(:content) { should match(/Good bye/) }
    # its(:content) { should match(/^total memory: \d+kB$/) }
    its(:content) { should match(/^uninitialized node key: $/) }
  end
end
