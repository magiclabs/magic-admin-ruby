# frozen_string_literal: true

module MagicAdmin
  module Http
    # Response Class
    class Response
      attr_reader :json_data, :http_body, :http_status, :message

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

      def initialize(http_resp)
        @json_data = JSON.parse(http_resp.body, symbolize_names: true)
        @http_body = http_resp.body
        @http_status = http_resp.code.to_i
        @message = json_data[:message]
      end

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
