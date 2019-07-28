module MItamae
  module ResourceExecutor
    class HTTPRequest < File
      RedirectLimitExceeded = Class.new(StandardError)
      HTTPClientError = Class.new(StandardError)
      HTTPServerError = Class.new(StandardError)
      HTTPUnknownError = Class.new(StandardError)

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

        curl(desired.action.to_s.upcase, desired.url, desired.message, desired.headers, desired.redirect_limit).stdout
      end

      def curl(method, url, body, headers, redirect_limit)
        if run_command(['which', 'curl'], error: false).exit_status != 0
          raise "`curl` command is not available. Please install curl to use mitamae's http_request."
        end

        command = ['curl', '-fsSL', '--max-redirs', "#{redirect_limit}", '-X', method, url]
        unless body.empty?
          command.concat(['-d', body])
        end
        headers.each do |key, value|
          command.concat(['-H', "#{key}: #{value}"])
        end

        result = run_command(command, error: false)
        unless result.success?
          MItamae.logger.error("#{result.stderr}")
          case result.exit_status
          when 22
            case result.stderr.gsub(/\Acurl:.*:\s(\d{3}.*)\z/, '\1')
            when /\A4\d{2}/
              raise HTTPClientError
            when /\A5\d{2}/
              raise HTTPServerError
            end
          when 47
            raise RedirectLimitExceeded
          end
          raise HTTPUnknownError
        end
        result
      end
    end
  end
end
