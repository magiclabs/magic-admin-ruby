# frozen_string_literal: true

# MagicAdmin::Util module to access utility methods for header info
module MagicAdmin
  # Util Class
  module Util
    def self.platform_info
      {
        platform: Config.platform,
        language: Config.language,
        language_version: Config.language_version,
        user_name: Config.user_name
      }
    end

    def self.user_agent
      {
        sdk_version: MagicAdmin::VERSION,
        publisher: Config.publisher,
        platform: platform_info
      }
    end

    def self.headers(secret_key)
      {
        "content-type": "application/json",
        "X-Magic-Secret-Key": secret_key,
        "User-Agent": Util.user_agent
      }
    end
  end
end
