# frozen_string_literal: true

module Magic
  module Util
    class << self
      def platform_info
        {
          platform: Config.platform,
          language: Config.language,
          language_version: Config.language_version,
          user_name: Config.user_name
        }
      end

      def user_agent
        {
          sdk_version: Magic.VERSION,
          publisher: Config.publisher,
          platform: platform_info
        }
      end
    end
  end
end
