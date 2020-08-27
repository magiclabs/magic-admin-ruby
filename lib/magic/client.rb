# frozen_string_literal: true

module Magic
  class Client
    attr_reader :secret_key, :http_client, :user, :token

    class << self
      def client(api_secret_key)
        @client ||= new(api_secret_key)
      end
    end

    def initialize(api_secret_key)
      @secret_key    = api_secret_key
      @http_client   = Http::Client
      @http_request  = Http::Request
      @http_response = Http::Response
      @user          = User.new
      @token         = Token.new
    end

    def call(method, path, options={})
      options.merge!({headers: headers})
      request = http_request.request(method, path, options)
      response = http_client.client(request)
      raise_errors(response)
      @http_response.new(response)
    end

    private

    def raise_errors(response)
      case response.status
        when 400 then raise BadRequestError
        when 401 then raise AuthenticationError
        when 403 then raise ForbiddenError
        when 429 then raise RateLimitingError
        else raise APIError
      end
    end

    def secret_key?
      !(secret_key.nil? || secret_key.empty?)
    end

    def headers
      raise AuthenticationError.new unless secret_key?
      {
        'content-type': 'application/json'
        'X-Magic-Secret-Key': secret_key,
        'User-Agent': Util.user_agent
      }
    end
  end
end
