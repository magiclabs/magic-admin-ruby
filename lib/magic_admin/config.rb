# frozen_string_literal: true

module MagicAdmin
  # Config Class
  class Config
    class << self
      attr_writer :request_retries, :request_timeout, :request_backoff

      def request_retries
        @request_retries || 3
      end

      def request_timeout
        @request_timeout || 10
      end

      def request_backoff
        @request_backoff || 0.03
      end

      def platform
        RUBY_PLATFORM
      end

      def language
        "ruby"
      end

      def language_version
        RUBY_VERSION
      end

      def user_name
        Etc.getpwnam(Etc.getlogin).gecos.split(/,/).first
      end

      def publisher
        "MagicLabs"
      end

      def api_base
        "https://api.magic.link"
      end
    end
  end
end
