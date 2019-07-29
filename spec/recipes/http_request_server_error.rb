execute 'apt-get update' # for installing curl
package 'curl'

http_request "/tmp/http_request_server_error.html" do
  url "http://httpbin.org/status/500?from=itamae"
end
