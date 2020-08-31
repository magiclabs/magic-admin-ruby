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
        headers = options.delete(:headers)
        params = options.delete(:params)
        req = Net::HTTP::Get.new(uri_with_params(url, params))
        request_with_headers(req, headers)
      end

      def post(url, options)
        req = Net::HTTP::Post.new(url)
        headers = options.delete(:headers)
        params = options
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

      def uri_with_params(uri, params)
        uri.query = URI.encode_www_form(params)
        uri
      end

      def request_with_params(req, params)
        req.set_form_data(params)
        req
      end
    end
  end
end
