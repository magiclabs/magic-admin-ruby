# frozen_string_literal: true

# Magic Ruby bindings
require "etc"
require "json"
require "net/http"
require "uri"
require "base64"
require "eth"

# Version
require "magic_admin/version"

# Magic API Classes
require "magic_admin/util"
require "magic_admin/config"
require "magic_admin/errors"

# HTTP Classes
require "magic_admin/http/client"
require "magic_admin/http/request"
require "magic_admin/http/response"

# Magic Resource Classes
require "magic_admin/token"
require "magic_admin/user"

class Magic
  attr_reader :secret_key, :api_base
  attr_reader :http_client, :http_request, :http_response

  def initialize(api_secret_key: ENV["MAGIC_API_SECRET_KEY"],
                 retries: 3,
                 timeout: 10,
                 backoff: 0.03)

    Config.request_retries = retries
    Config.request_timeout = timeout
    Config.request_backoff = backoff

    @secret_key    = api_secret_key
    @api_base      = Config.api_base

    @http_client   = Http::Client
    @http_request  = Http::Request
    @http_response = Http::Response
  end

  def call(method, path, options = {})
    options.merge!({ headers: headers })
    url = URI("#{api_base}#{path}")
    request = http_request.request(method, url, options)
    response = http_client.client(request, url)
    http_response.from_net_http(response, request)
  end

  def user
    MagicAdmin::User.new(self)
  end

  def token
    MagicAdmin::Token
  end

  private

  def secret_key?
    !(secret_key.nil? || secret_key.empty?)
  end

  def headers
    raise UnauthorizedError, "Unauthorized" unless secret_key?

    {
      "content-type": "application/json",
      "X-Magic-Secret-Key": secret_key,
      "User-Agent": MagicAdmin::Util.user_agent
    }
  end
end
