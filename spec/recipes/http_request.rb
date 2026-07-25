execute 'apt-get update' # for installing curl
package 'curl'

http_request "/tmp/http_request.html" do
  url "http://httpbin:8080/get?from=itamae"
end

http_request "/tmp/http_request_delete.html" do
  action :delete
  url "http://httpbin:8080/delete?from=itamae"
end

http_request "/tmp/http_request_post.html" do
  action :post
  message "love=sushi"
  url "http://httpbin:8080/post?from=itamae"
end

http_request "/tmp/http_request_put.html" do
  action :put
  message "love=sushi"
  url "http://httpbin:8080/put?from=itamae"
end

http_request "/tmp/http_request_headers.html" do
  headers "User-Agent" => "Itamae"
  url "http://httpbin:8080/get"
end

http_request "/tmp/http_request_redirect.html" do
  redirect_limit 1
  url "http://httpbin:8080/redirect-to?url=http%3A%2F%2Fhttpbin%3A8080%2Fget%3Ffrom%3Ditamae"
end

http_request "/tmp/https_request.json" do
  url "https://httpbin-tls:8443/get?from=itamae"
end
