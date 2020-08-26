# frozen_string_literal: true

module Magic
  module Http
    class Client
      attr_reader :retries, :backoff, :timeout, :url

      class << self
        def client(request)
          new.client(request)
        end
      end

      def initialize
        @retries = Config.request_retries
        @backoff = Config.request_backoff
        @timeout = Config.request_backoff
        @url     = URI(Config.api_base)
      end

      def client(request)
        backoff_retries = backoff_daley
        begin
          Net::HTTP.start(url.host, url.port) do |http|
            http.read_timeout = timeout
            http.request(request)
          end
        rescue StandardError
          if delay = retries.shift
            sleep delay
            retry
          else
            raise APIConnectionError
          end
        end
      end

      private

      def backoff_daley
        daley = []
        retries.downto(1) do |retry_attempt|
          retry_delay = (backoff * (2 ** (retry_attempt - 1)))
          daley << retry_delay
        end
        daley
      end
    end
  end
end

