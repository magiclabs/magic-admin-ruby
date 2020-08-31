# frozen_string_literal: true

module MagicAdmin
  module Http
    # Client Class
    class Client
      attr_reader :retries, :backoff, :timeout

      class << self
        def client(request, url)
          new.client(request, url)
        end
      end

      def initialize
        @retries = Config.request_retries
        @backoff = Config.request_backoff
        @timeout = Config.request_timeout
      end

      def client(request, url)
        backoff_retries = backoff_daley
        begin
          Net::HTTP.start(url.host, url.port, use_ssl: use_ssl?(url)) do |http|
            http.read_timeout = timeout
            http.request(request)
          end
        rescue
          delay = backoff_retries.shift
          if delay
            sleep delay
            retry
          end
          raise RequestTimeoutError, "TODO ERROR MESSAGE"
        end
      end

      private

      def use_ssl?(url)
        url.scheme == "https"
      end

      def backoff_daley
        daley = []
        retries.downto(1) do |retry_attempt|
          retry_delay = (backoff * (2**(retry_attempt - 1)))
          daley << retry_delay
        end
        daley
      end
    end
  end
end
