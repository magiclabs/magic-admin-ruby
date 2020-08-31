# frozen_string_literal: true

module MagicAdmin
  # MagicError Class
  class MagicError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end

  class DIDTokenError < MagicError; end
  class APIConnectionError < MagicError; end

  # HTTPRequestError Class
  class HTTPRequestError < MagicError
    attr_reader :http_status
    attr_reader :http_code
    attr_reader :http_response
    attr_reader :http_message
    attr_reader :http_error_code
    attr_reader :http_request_params
    attr_reader :http_request_data
    attr_reader :http_method

    def initialize(message, opt)
      super(message)
      @http_status = opt[:http_status]
      @http_code = opt[:http_code]
      @http_response = opt[:http_response]
      @http_message = opt[:http_message]
      @http_error_code = opt[:http_error_code]
      @http_request_params = opt[:http_request_params]
      @http_request_data = opt[:http_request_data]
      @http_method = opt[:http_method]
    end
  end

  class TooManyRequestsError < HTTPRequestError; end
  class BadRequestError < HTTPRequestError; end
  class UnauthorizedError < HTTPRequestError; end
  class ForbiddenError < HTTPRequestError; end
  class RequestTimeoutError < HTTPRequestError; end
  class APIError < HTTPRequestError; end
end
