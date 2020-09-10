# frozen_string_literal: true

# MagicAdmin module provides methods/classes to interact with Magic Admin
module MagicAdmin
  # MagicAdmin::MagicError class
  class MagicError < StandardError
    # attribute reader for error message
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
    # attribute reader for http response status
    attr_reader :http_status

    # attribute reader for http response code
    attr_reader :http_code

    # attribute reader for http response
    attr_reader :http_response

    # attribute reader for http response message
    attr_reader :http_message

    # attribute reader for http response error code
    attr_reader :http_error_code

    # attribute reader for http request params
    attr_reader :http_request_params

    # attribute reader for http request data
    attr_reader :http_request_data

    # attribute reader for http request method
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
