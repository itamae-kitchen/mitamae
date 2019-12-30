require 'spec_helper'

describe 'file resource' do
  before(:all) do
    pending 'failing with mruby 2.1.0'
    apply_recipe('file')
  end

  describe file('/tmp/file') do
    it { should be_file }
    its(:content) { should match(/Hello World/) }
    it { should be_mode 777 }
  end

  describe file('/tmp/never_exist3') do
    it { should_not be_file }
  end

  describe file('/tmp/never_exist4') do
    it { should_not be_file }
  end

  describe file('/tmp/file_create_without_content') do
    its(:content) { should eq("Hello, World") }
    it { should be_mode 600 }
    it { should be_owned_by "itamae" }
    it { should be_grouped_into "itamae" }
  end

  describe file('/tmp/file_without_content_change_updates_mode_and_owner') do
    its(:content) { should eq("Hello, world") }
    it { should be_mode 666 }
    it { should be_owned_by "itamae2" }
    it { should be_grouped_into "itamae2" }
  end

  describe file('/tmp/file_with_content_change_updates_timestamp') do
    its(:mtime) { should be > DateTime.iso8601("2016-05-01T01:23:45Z") }
  end

  describe file('/tmp/file_without_content_change_keeping_timestamp') do
    its(:mtime) { should eq(DateTime.iso8601("2016-05-01T12:34:56Z")) }
  end

  describe file('/tmp/file_edit_sample') do
    it { should be_file }
    its(:content) { should eq("Hello, Itamae") }
    it { should be_mode 400 }
    it { should be_owned_by "itamae2" }
    it { should be_grouped_into "itamae2" }
  end

  describe file('/tmp/file_edit_keeping_mode_owner') do
    it { should be_file }
    its(:content) { should eq("Hello, Itamae") }
    it { should be_mode 444 }
    it { should be_owned_by "itamae" }
    it { should be_grouped_into "itamae" }
  end

  describe file('/tmp/root_owned_tempfile_operated_by_normal_user') do
    it { should be_file }
    it { should be_owned_by "itamae" }
    it { should be_grouped_into "itamae" }
  end

  describe file('/tmp/file_edit_with_content_change_updates_timestamp') do
    its(:mtime) { should be > DateTime.iso8601("2016-05-02T01:23:45Z") }
  end

  describe file('/tmp/file_edit_without_content_change_keeping_timestamp') do
    its(:mtime) { should eq(DateTime.iso8601("2016-05-02T12:34:56Z")) }
  end

  describe file('/tmp/file_edit_notifies') do
    its(:content) { should eq("1") }
  end

  describe file('/tmp/empty_file_with_owner') do
    it { should be_file }
    its(:content) { should eq('') }
    it { should be_mode 600 }
    it { should be_owned_by "itamae" }
    it { should be_grouped_into "itamae" }
  end

  describe file('/tmp/explicit_empty_file_with_owner') do
    it { should be_file }
    its(:content) { should eq('') }
    it { should be_mode 600 }
    it { should be_owned_by "itamae" }
    it { should be_grouped_into "itamae" }
  end

  describe file('/tmp/file_changed_sample') do
    it { should be_file }
    its(:content) { should eq('Changed') }
  end

  describe file('/tmp/file_changed_notifies') do
    its(:content) { should eq('1') }
  end
end
