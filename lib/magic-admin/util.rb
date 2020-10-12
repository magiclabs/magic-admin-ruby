# frozen_string_literal: true

module MagicAdmin

  module Util

    # Description:
    #   Method provides you platform information hash
    #
    # Returns:
    #   hash with following keys.
    #       platform:
    #       language:
    #       language_version:
    #       user_name:
    def self.platform_info
      {
        platform: Config.platform,
        language: Config.language,
        language_version: Config.language_version,
        user_name: Config.user_name
      }
    end

    # Description:
    #   Method provides you user agent hash
    #
    # Returns:
    #   hash with following keys.
    #       sdk_version:
    #       publisher:
    #       platform:
    def self.user_agent
      {
        sdk_version: MagicAdmin::VERSION,
        publisher: Config.publisher,
        platform: platform_info
      }
    end

    # Description:
    #   Method provides you request headers hash
    #
    # Arguments:
    #   secret_key: API Secret Key.
    #
    # Returns:
    #   hash with following keys.
    #       content-type:
    #       X-Magic-Secret-Key:
    #       User-Agent:
    def self.headers(secret_key)
      {
        "content-type": "application/json",
        "X-Magic-Secret-Key": secret_key,
        "User-Agent": Util.user_agent
      }
    end

  end
end
