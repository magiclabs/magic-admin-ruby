# frozen_string_literal: true

module MagicAdmin
  module Http
    # Client Class
    class Client
      attr_reader :retries, :backoff, :timeout, :base_url
      attr_reader :http_request, :http_response

      def initialize(api_base, req_retries, req_timeout, req_backoff)
        @retries = req_retries
        @backoff = req_backoff
        @timeout = req_timeout
        @base_url = api_base
        @http_request = Request
        @http_response = Response
      end

      def call(method, path, options)
        url = URI("#{base_url}#{path}")
        req = http_request.request(method, url, options)
        resp = backoff_retries(retries, backoff) do
          base_client(url, req, timeout)
        end
        http_response.from_net_http(resp, req)
      end

      private

      def backoff_retries(max_retries, backoff_factor, &block)
        attempts = 0
        begin
          attempts += 1
          block.call
        rescue StandardError => e
          raise e if attempts >= max_retries

          sleep_seconds = backoff_factor * (2**(attempts - 1))
          sleep sleep_seconds
          retry
        end
      end

      def use_ssl?(url)
        url.scheme == "https"
      end

      def base_client(url, request, read_timeout)
        Net::HTTP.start(url.host, url.port, use_ssl: use_ssl?(url)) do |http|
          http.read_timeout = read_timeout
          http.request(request)
        end
      end
    end
  end
end
