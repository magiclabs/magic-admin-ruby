# frozen_string_literal: true

module Magic
  module Http
    class Response
      attr_accessor :json_data, :http_body, :http_status

      def self.from_net_http(http_resp)
        resp = Response.new
        resp.json_data = JSON.parse(http_resp.body, symbolize_names: true)
        resp.http_body = http_resp.body
        resp.http_status = http_resp.code.to_i
        resp
      end
    end
  end
end
