# frozen_string_literal: true

module MagicAdmin
  module Http
    # Client Class
    class Client
      # attribute reader for magic api max retries
      attr_reader :retries

      # attribute reader for magic api backoff factor
      attr_reader :backoff

      # attribute reader for magic api timeout
      attr_reader :timeout

      # attribute reader for magic api base api url
      attr_reader :base_url

      # attribute reader for magic http request class
      attr_reader :http_request

      # attribute reader for magic http response class
      attr_reader :http_response

      # The constructor allows you to configure HTTP request strategy
      # when your application interacting with the Magic API
      #
      # Arguments:
      #   api_base: api base url.
      #   req_retries: Total number of retries to allow.
      #   req_timeout: A period of time the request is going to wait for a response.
      #   req_backoff: A backoff factor to apply between retry attempts.
      #
      # Returns:
      #   A Http Client object that provides access to all the supported resources.
      #
      # Examples:
      #   Client.new(<api_base>, <req_retries>, <req_timeout>, <req_backoff>)
      #

      def initialize(api_base, req_retries, req_timeout, req_backoff)
        @retries = req_retries.to_i
        @backoff = req_backoff.to_f
        @timeout = req_timeout.to_i
        @base_url = api_base
        @http_request = Request
        @http_response = Response
      end

      # Description:
      #   call create http request and provide response
      #
      # Arguments:
      #   method: http method
      #   path: api path
      #   options: a hash contains params and headers for request
      #
      # Returns:
      #   response object
      #

      def call(method, path, options)
        url = URI("#{base_url}#{path}")
        req = http_request.request(method, url, options)
        resp = backoff_retries(retries, backoff) do
          base_client(url, req, timeout)
        end
        http_response.from_net_http(resp, req)
      end

      private

      # Description:
      #   backoff_retries implementations of retries strategy with backoff factor
      #
      # Arguments:
      #   max_retries: max retries count
      #   backoff_factor: backoff factor for configure delay in retries
      #   block: block of code that uses retries backoff strategy
      #
      # Returns:
      #   it returns, block return object
      #

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

      # Description:
      #   use_ssl? provide true if url uses https protocol otherwise false
      #
      # Arguments:
      #   url: max retries count
      #
      # Returns:
      #   boolean value
      #

      def use_ssl?(url)
        url.scheme == "https"
      end

      # Description:
      #   base_client is base http request/response mechanism
      #
      # Arguments:
      #   url: request url
      #   request: request object
      #   read_timeout: read_timeout for request
      #
      # Returns:
      #   response
      #

      def base_client(url, request, read_timeout)
        Net::HTTP.start(url.host, url.port, use_ssl: use_ssl?(url)) do |http|
          http.read_timeout = read_timeout
          http.request(request)
        end
      end
    end
  end
end
