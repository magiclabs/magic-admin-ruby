# frozen_string_literal: true

module MagicAdmin
  module Http
    # Request Class
    class Request
      class << self
        def request(method, url, options)
          case method
          when :get, "get" then new.get(url, options)
          when :post, "post" then new.post(url, options)
          else raise BadRequestError, "TODO ERROR MESSAGE"
          end
        end
      end

      def get(url, options)
        headers = options[:headers] || {}
        params = options[:params] || {}
        url = url_with_params(url, params)
        req = Net::HTTP::Get.new(url)
        request_with_headers(req, headers)
      end

      def post(url, options)
        headers = options[:headers] || {}
        params = options[:params] || {}
        req = Net::HTTP::Post.new(url)
        req = request_with_headers(req, headers)
        request_with_params(req, params)
      end

      private

      def request_with_headers(req, headers)
        headers.each do |key, val|
          req[key.to_s] = val
        end
        req
      end

      def url_with_params(url, params)
        url.query = URI.encode_www_form(params)
        url
      end

      def request_with_params(req, params)
        req.set_form_data(params)
        req
      end
    end
  end
end
