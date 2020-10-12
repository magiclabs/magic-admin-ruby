# frozen_string_literal: true

module MagicAdmin

  module Http

    # Http Request and its methods are accessible
    # on the Magic instance by the http_client.http_request attribute.
    # It provides methods to interact with the http_request.
    class Response

      # attribute reader for response data
      attr_reader :data

      # attribute reader for response body
      attr_reader :content

      # attribute reader for response status_code
      attr_reader :status_code

      # Description:
      #   Method parse Magic API response
      #
      # Arguments:
      #   http_resp: Magic API response.
      #   request: request object.
      #
      # Returns:
      #   A HTTP Response object or raise an error
      def self.from_net_http(http_resp, request)
        resp = Response.new(http_resp)
        error = case http_resp
                when Net::HTTPUnauthorized then AuthenticationError
                when Net::HTTPBadRequest then BadRequestError
                when Net::HTTPForbidden then ForbiddenError
                when Net::HTTPTooManyRequests then RateLimitingError
                when Net::HTTPServerError then APIError
                when Net::HTTPGatewayTimeout then APIError
                when Net::HTTPServiceUnavailable then APIError
                when Net::HTTPBadGateway then APIError
                end
        return resp unless error

        raise error.new(resp.data[:message], resp.error_opt(request))
      end

      # The constructor allows you to create HTTP Response Object
      # when your application interacting with the Magic API
      #
      # Arguments:
      #   http_resp: Magic API response.
      #
      # Returns:
      #   A HTTP Response object that provides access to
      #   all the supported resources.
      #
      # Examples:
      #   Response.new(<http_resp>)
      def initialize(http_resp)
        @content = http_resp.body
        @data = JSON.parse(http_resp.body, symbolize_names: true)
        @status_code = http_resp.code.to_i
      end

      # Description:
      #   Method provides you error info hash
      #
      # Arguments:
      #   request: request object.
      #
      # Returns:
      #   hash with following keys.
      #   http_status:
      #   status_code:
      #   http_response:
      #   http_message:
      #   http_error_code:
      #   http_request_params:
      #   http_request_header:
      #   http_method:
      def error_opt(request)
        {
          http_status: data[:status],
          http_code: status_code,
          http_response: content,
          http_message: data[:message],
          http_error_code: data[:error_code],
          http_request_params: request.body,
          http_method: request.method
        }
      end

    end
  end
end
