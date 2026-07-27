execute 'apt-get update' # for installing curl
package 'curl'

# go-httpbin rejects `/status/999` with 400, which is indistinguishable from an ordinary client
# error. Hitting a port nobody listens on makes curl fail with 7 instead, which is neither a 4xx
# nor a 5xx and therefore keeps exercising the "unknown error" branch.
http_request "/tmp/http_request_unknown_error.html" do
  url "http://httpbin:9"
end
