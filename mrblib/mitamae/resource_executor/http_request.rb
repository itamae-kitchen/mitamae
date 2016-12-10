module MItamae
  module ResourceExecutor
    class HTTPRequest < File
      private

      def set_desired_attributes(desired, action)
        desired.exist = true
        desired.content = fetch_content(desired)
      end

      def fetch_content(desired)
        client = HttpRequest.new
        case desired.action
        when :get
          response = client.get(desired.url, desired.message, desired.headers)
        when :post
          response = client.post(desired.url, desired.message, desired.headers)
        when :put
          response = client.put(desired.url, desired.message, desired.headers)
        when :delete
          response = client.delete(desired.url, desired.headers)
        end
        response.body
      end
    end
  end
end
