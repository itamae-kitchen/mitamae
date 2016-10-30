%w!/tmp/remote_file /tmp/remote_file_auto!.each do |f|
  describe file(f) do
    it { should be_file }
    its(:content) { should match(/Hello Itamae/) }
  end
end
