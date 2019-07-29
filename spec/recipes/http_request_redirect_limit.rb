execute 'apt-get update' # for installing curl
package 'curl'

http_request "/tmp/http_request_redirect_limit.html" do
  redirect_limit 1
  url "http://httpbin.org/absolute-redirect/3?from=itamae"
end
