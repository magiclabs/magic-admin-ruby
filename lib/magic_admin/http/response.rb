# frozen_string_literal: true

module MagicAdmin
  module Http
    # Response Class
    class Response
      attr_reader :json_data, :http_body, :http_status, :message

      def self.from_net_http(http_resp, request)
        resp = Response.new(http_resp)
        case http_resp
        when Net::HTTPBadRequest
          raise BadRequestError.new(resp.message, resp.error_opt(request))
        when Net::HTTPUnauthorized
          raise UnauthorizedError.new(resp.message, resp.error_opt(request))
        when Net::HTTPForbidden
          raise ForbiddenError.new(resp.message, resp.error_opt(request))
        when Net::HTTPTooManyRequests
          raise TooManyRequestsError.new(resp.message, resp.error_opt(request))
        else resp
        end
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
