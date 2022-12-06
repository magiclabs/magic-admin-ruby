# frozen_string_literal: true

# Magic Ruby bindings
require "etc"
require "json"
require "net/http"
require "uri"
require "base64"
require "eth"

# Version
require "magic-admin/version"

# Magic API Classes
require "magic-admin/util"
require "magic-admin/config"
require "magic-admin/errors"

# HTTP Classes
require "magic-admin/http/client"
require "magic-admin/http/request"
require "magic-admin/http/response"

# Magic Resource Classes
require "magic-admin/resource/token"
require "magic-admin/resource/user"
require "magic-admin/resource/wallet"

# Magic Class to access resources
class Magic
  RETRIES = 3
  TIMEOUT = 5
  BACKOFF = 0.02

  # attribute reader for magic api secret key
  attr_reader :secret_key

  # attribute reader for magic http client
  attr_reader :http_client

  # The constructor allows you to specify your own API secret key
  # and HTTP request strategy when your application interacting
  # with the Magic API.
  #
  # It will automatically configure required arguments
  # using the following environment variables
  #   MAGIC_API_SECRET_KEY
  #   MAGIC_API_RETRIES
  #   MAGIC_API_TIMEOUT
  #   MAGIC_API_BACKOFF
  #
  # Arguments:
  #   api_secret_key: Your API Secret Key retrieved from the Magic Dashboard.
  #   retries: Total number of retries to allow.
  #   timeout: A period of time the request is going to wait for a response.
  #   backoff: A backoff factor to apply between retry attempts.
  #
  # Returns:
  #   A Magic object that provides access to all the supported resources.
  #
  # Examples:
  #
  #   Magic.new
  #   Magic.new api_secret_key: "SECRET_KEY>"
  #   Magic.new api_secret_key: "SECRET_KEY>",
  #             retries: 2,
  #             timeout: 2,
  #             backoff: 0.2
  #
  #

  def initialize(api_secret_key: nil,
                 retries: nil,
                 timeout: nil,
                 backoff: nil)
    secret_key!(api_secret_key)
    http_client!(retries, timeout, backoff)
  end

  # Description:
  #   Method provides you User object
  #   for interacting with the Magic API.
  #
  # Returns:
  #   A User object that provides access to
  #   all the supported resources.

  def user
    MagicAdmin::Resource::User.new(self)
  end

  # Description:
  #   Method provides you Token object
  #   for various utility methods of Token.
  #
  # Returns:
  #   A Token object that provides access to
  #   all the supported resources.

  def token
    MagicAdmin::Resource::Token.new
  end

  private

  def secret_key?
    !(secret_key.nil? || secret_key.empty?)
  end

  def secret_key!(api_secret_key)
    @secret_key = api_secret_key || ENV["MAGIC_API_SECRET_KEY"]
    message = "Magic api secret key was not found."

    raise MagicAdmin::MagicError, message unless secret_key?
  end

  def configure_retries(retries)
    retries || ENV["MAGIC_API_RETRIES"] || RETRIES
  end

  def configure_timeout(timeout)
    timeout || ENV["MAGIC_API_TIMEOUT"] || TIMEOUT
  end

  def configure_backoff(backoff)
    backoff || ENV["MAGIC_API_BACKOFF"] || BACKOFF
  end

  def http_client!(retries, timeout, backoff)
    @http_client = MagicAdmin::Http::Client
                   .new(MagicAdmin::Config.api_base,
                        configure_retries(retries),
                        configure_timeout(timeout),
                        configure_backoff(backoff))
  end
end
