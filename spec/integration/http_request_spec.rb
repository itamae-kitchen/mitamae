require 'spec_helper'

describe 'http_request resource' do
  before(:all) do
    expect {
      apply_recipe('http_request_without_curl', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)
    expect {
      apply_recipe('http_request_client_error', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)
    expect {
      apply_recipe('http_request_server_error', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)
    expect {
      apply_recipe('http_request_unknown_error', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)
    expect {
      apply_recipe('http_request_redirect_limit', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)
    apply_recipe('http_request')
  end

  describe file('/tmp/http_request.html') do
    it { should be_file }
    its(:content) { should match(/"from": ?"itamae"/) }
  end

  describe file('/tmp/http_request_delete.html') do
    it { should be_file }
    its(:content) { should match(/"from": ?"itamae"/) }
  end

  describe file('/tmp/http_request_post.html') do
    it { should be_file }
    its(:content) do
      should match(/"from": ?"itamae"/)
      should match(/"love": ?"sushi"/)
    end
  end

  describe file('/tmp/http_request_put.html') do
    it { should be_file }
    its(:content) do
      should match(/"from": ?"itamae"/)
      should match(/"love": ?"sushi"/)
    end
  end

  describe file('/tmp/http_request_headers.html') do
    it { should be_file }
    its(:content) { should match(/"User-Agent": ?"Itamae"/) }
  end

  describe file('/tmp/http_request_redirect.html') do
    it { should be_file }
    its(:content) { should match(/"from": ?"itamae"/) }
  end

  describe file('/tmp/https_request.json') do
    it { should be_file }
    its(:content) { should match(/"from": ?"itamae"/) }
  end
end
