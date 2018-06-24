module MItamae
  module ResourceExecutor
    class HTTPRequest < File
      HTTP_METHODS = [
        :get,
        :post,
        :put,
        :delete,
      ]

      private

      def set_desired_attributes(desired, action)
        desired.exist = true
        desired.content = fetch_content(desired)
      end

      def fetch_content(desired)
        unless HTTP_METHODS.include?(desired.action)
          raise "invalid http_request action: #{desired.action.inspect}"
        end

        curl(desired.action.to_s.upcase, desired.url, desired.message, desired.headers).stdout
      end

      def curl(method, url, body, headers)
        if run_command(['which', 'curl'], error: false).exit_status != 0
          raise "`curl` command is not available. Please install curl to use mitamae's http_request."
        end

        command = ['curl', '-sL', '-X', method, url]
        unless body.empty?
          command.concat(['-d', body])
        end
        headers.each do |key, value|
          command.concat(['-H', "#{key}: #{value}"])
        end
        run_command(command, error: false)
      end
    end
  end
end
