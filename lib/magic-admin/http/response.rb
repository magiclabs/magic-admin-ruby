# frozen_string_literal: true

# MagicAdmin module provides methods/classes to interact with Magic Admin
module MagicAdmin
  # Http module for HTTP resources
  module Http
    # Http Request and its methods are accessible
    # on the Magic instance by the http_client.http_request attribute.
    # It provides methods to interact with the http_request.
    class Response
      # attribute reader for response json_data
      attr_reader :json_data

      # attribute reader for response body
      attr_reader :http_body

      # attribute reader for response status
      attr_reader :http_status

      # attribute reader for response message
      attr_reader :message

      # Description:
      #   Method parse Magic API response
      #
      # Arguments:
      #   http_resp: Magic API response.
      #   request: request object.
      #
      # Returns:
      #   A HTTP Response object or raise an error
      #

      def self.from_net_http(http_resp, request)
        resp = Response.new(http_resp)
        error = case http_resp
                when Net::HTTPBadRequest then BadRequestError
                when Net::HTTPUnauthorized then UnauthorizedError
                when Net::HTTPForbidden then ForbiddenError
                when Net::HTTPTooManyRequests then TooManyRequestsError
                end
        return resp unless error

        message = resp.message
        error_options = resp.error_opt(request)
        raise error.new(message, error_options)
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
      #

      def initialize(http_resp)
        @json_data = JSON.parse(http_resp.body, symbolize_names: true)
        @http_body = http_resp.body
        @http_status = http_resp.code.to_i
        @message = json_data[:message]
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
      #   http_code:
      #   http_response:
      #   http_message:
      #   http_error_code:
      #   http_request_params:
      #   http_request_header:
      #   http_method:

      def error_opt(request)
        {
          http_status: http_status,
          http_code: nil,
          http_response: http_body,
          http_message: message,
          http_error_code: nil,
          http_request_params: request.body,
          http_request_header: request.to_hash,
          http_method: request.method
        }
      end
    end
  end
end
