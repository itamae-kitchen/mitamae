execute 'apt-get update' # for installing curl
package 'curl'

http_request "/tmp/http_request.html" do
  url "http://httpbin.org/get?from=itamae"
end

http_request "/tmp/http_request_delete.html" do
  action :delete
  url "http://httpbin.org/delete?from=itamae"
end

http_request "/tmp/http_request_post.html" do
  action :post
  message "love=sushi"
  url "http://httpbin.org/post?from=itamae"
end

http_request "/tmp/http_request_put.html" do
  action :put
  message "love=sushi"
  url "http://httpbin.org/put?from=itamae"
end

http_request "/tmp/http_request_headers.html" do
  headers "User-Agent" => "Itamae"
  url "http://httpbin.org/get"
end

http_request "/tmp/http_request_redirect.html" do
  redirect_limit 1
  url "http://httpbingo.org/redirect-to?url=https%3A%2F%2Fhttpbingo.org%2Fget%3Ffrom%3Ditamae"
end

http_request "/tmp/https_request.json" do
  url "https://httpbin.org/get?from=itamae"
end
