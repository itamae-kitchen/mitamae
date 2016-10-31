require 'spec_helper'

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
