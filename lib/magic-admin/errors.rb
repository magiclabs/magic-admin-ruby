# frozen_string_literal: true

module MagicAdmin
  # MagicAdmin::MagicError class
  class MagicError < StandardError
    attr_reader :message

    # Description:
    #   The constructor allows you to specify error message
    #
    # Arguments:
    #   message: error message.

    def initialize(message)
      @message = message
    end
  end

  # MagicAdmin::MagicError class
  class DIDTokenError < MagicError; end

  # MagicAdmin::MagicError class
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

    # Description:
    #   The constructor allows you to specify error message
    #   and HTTP request and response info
    #
    # Arguments:
    #   message: request error message.
    #   opt: hash of request and response info of following keys.
    #   http_status:
    #   http_code:
    #   http_response:
    #   http_message:
    #   http_error_code:
    #   http_request_params:
    #   http_request_params:
    #   http_request_data:
    #   http_method:
    # Returns:
    #   A Error object that provides additional error info for magic api call.

    def initialize(message, opt = {})
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

  # MagicAdmin::TooManyRequestsError class
  class TooManyRequestsError < HTTPRequestError; end

  # MagicAdmin::BadRequestError class
  class BadRequestError < HTTPRequestError; end

  # MagicAdmin::UnauthorizedError class
  class UnauthorizedError < HTTPRequestError; end

  # MagicAdmin::ForbiddenError class
  class ForbiddenError < HTTPRequestError; end

  # MagicAdmin::RequestTimeoutError class
  class RequestTimeoutError < HTTPRequestError; end

  # MagicAdmin::APIError class
  class APIError < HTTPRequestError; end
end
