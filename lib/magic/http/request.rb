# frozen_string_literal: true

module Magic
  module Http
    class Request
      class << self
        def request(method, path, options)
          new.send(method, path, options)
        end
      end

      def get(path, options)
        Net::HTTP::Get.new(path)
      end

      def post(path, options)
        Net::HTTP::Post.new(request_path)
      end
    end
  end
end
