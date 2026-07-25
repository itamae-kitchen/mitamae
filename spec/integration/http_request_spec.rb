require 'spec_helper'
require 'tempfile'

describe 'http_request resource' do
  # `apply_recipe` passes `redirect:` straight to `system`, where a String value for `err:`
  # is a filename, so mitamae's stderr can be captured without touching the spec helper.
  def stderr_of_failed_recipe(recipe)
    Tempfile.create('mitamae-stderr') do |f|
      expect {
        apply_recipe(recipe, redirect: { out: File::NULL, err: f.path })
      }.to raise_error(RuntimeError)
      File.read(f.path)
    end
  end

  before(:all) do
    # This has to run before any other recipe installs curl.
    expect {
      apply_recipe('http_request_without_curl', redirect: { out: File::NULL })
    }.to raise_error(RuntimeError)

    @stderr = {}
    %w[client_error server_error unknown_error redirect_limit].each do |name|
      @stderr[name] = stderr_of_failed_recipe("http_request_#{name}")
    end

    apply_recipe('http_request')
  end

  it 'raises HTTPClientError for a 4xx response' do
    expect(@stderr['client_error']).to include('HTTPClientError')
  end

  it 'raises HTTPServerError for a 5xx response' do
    expect(@stderr['server_error']).to include('HTTPServerError')
  end

  it 'raises HTTPUnknownError for a failure that is neither 4xx nor 5xx' do
    expect(@stderr['unknown_error']).to include('HTTPUnknownError')
  end

  it 'raises RedirectLimitExceeded when the redirect limit is exceeded' do
    expect(@stderr['redirect_limit']).to include('RedirectLimitExceeded')
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
    its(:content) { should match(/"from":\s*\[\s*"itamae"\s*\]/) }
  end

  describe file('/tmp/https_request.json') do
    it { should be_file }
    its(:content) { should match(/"from": ?"itamae"/) }
  end
end
