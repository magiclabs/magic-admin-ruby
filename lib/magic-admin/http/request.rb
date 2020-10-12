# frozen_string_literal: true

module MagicAdmin

  module Http

    # Http Request and its methods are accessible
    # on the Magic instance by the http_client.http_request attribute.
    # It provides methods to interact with the http_request.
    class Request

      class << self
        # Description:
        #   Method configure request object and provides request object
        #   based on method argument.
        #
        # Arguments:
        #   method: http method
        #   url: get request url
        #   options: a hash contains params and headers for request
        #
        # Returns:
        #   A request object.
        def request(method, url, options)
          case method
          when :get, "get" then new.get(url, options)
          when :post, "post" then new.post(url, options)
          else
            raise APIError.new("Request method not supported.", { http_method: method })
          end
        end
      end

      # Description:
      #   Method configure request object and provides you get request object.
      #
      # Arguments:
      #   url: get request url
      #   options: a hash contains params and headers for request
      #
      # Returns:
      #   A get request object.
      def get(url, options)
        headers = options[:headers] || {}
        params = options[:params] || {}
        url = url_with_params(url, params)
        req = Net::HTTP::Get.new(url)
        request_with_headers(req, headers)
      end

      # Description:
      #   Method configure request object and provides you post request object.
      #
      # Arguments:
      #   url: post request url
      #   options: a hash contains params and headers for request
      #
      # Returns:
      #   A post request object.
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
        req.body = params.to_json
        req
      end

    end
  end
end
