# frozen_string_literal: true

module Magic
  class Config
    class << self
      def request_retries
        @request_retries || 0
      end

      def request_retries=(retries)
        @request_retries = retries
      end

      def request_timeout
        @request_timeout
      end

      def request_timeout=(timeout)
        @request_timeout = timeout
      end

      def request_backoff
        @request_backoff || 1
      end

      def request_backoff=(backoff)
        @request_backoff = backoff
      end

      def platform
        RUBY_PLATFORM
      end

      def language
        'ruby'
      end

      def language_version
        RUBY_VERSION
      end

      def user_name
        Etc.getpwnam(Etc.getlogin).gecos.split(/,/).first
      end

      def sdk_version
        Magic.VERSION
      end

      def publisher
        'MagicLabs'
      end

      def api_base
        "https://api.magic.link"
      end
    end
  end
end
