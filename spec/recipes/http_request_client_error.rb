execute 'apt-get update' # for installing curl
package 'curl'

http_request "/tmp/http_request_client_error.html" do
  url "http://httpbin.org/status/400?from=itamae"
end
