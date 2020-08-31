# frozen_string_literal: true

module MagicAdmin
  # Util Class
  class Util
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
          sdk_version: MagicAdmin::VERSION,
          publisher: Config.publisher,
          platform: platform_info
        }
      end
    end
  end
end
