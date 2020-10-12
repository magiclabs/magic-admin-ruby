# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Http::Response do
  let(:stub_response_body) do
    { "data" => {}, "error_code" => "", "message" => "", "status" => "ok" }
  end

  let(:http_resp) do
    double(
      "http_resp",
      body: stub_response_body.to_json,
      code: 200,
      message: "ok"
    )
  end

  let(:url) { URI("https://api.magic.link//v1/admin/auth/user/get") }
  let(:request) { MagicAdmin::Http::Request.request(:get, url, {}) }

  subject { described_class.new(http_resp) }

  it "present attr_reader" do
    expect(subject).to respond_to(:data)
    expect(subject).to respond_to(:content)
    expect(subject).to respond_to(:status_code)
  end

  context "#error_opt" do
    it "return response" do
      expect(subject.error_opt(request)).to include(
        :http_status,
        :http_code,
        :http_response,
        :http_message,
        :http_error_code,
        :http_request_params,
        :http_method
      )
    end
  end

  describe "class_methods" do
    context ".from_net_http" do
      it "with valid request" do
        reps = described_class.from_net_http(http_resp, request)
        expect(reps).to be_instance_of(MagicAdmin::Http::Response)

        expect(reps.status_code).to eq(200)
      end

      context "with invalid request" do
        it "raise error BadRequestError" do
          error_resp = instance_double(
            Net::HTTPBadRequest,
            body: stub_response_body.to_json,
            code: 400,
            message: "HTTP Bad Request"
          )

          allow(Net::HTTPBadRequest).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::BadRequestError)
        end

        it "raise error HTTPUnauthorized" do
          error_resp = instance_double(
            Net::HTTPUnauthorized,
            body: stub_response_body.to_json,
            code: 401,
            message: "HTTP Unauthorized  Request Error"
          )

          allow(Net::HTTPUnauthorized).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::AuthenticationError)
        end

        it "raise error HTTPForbidden" do
          error_resp = instance_double(
            Net::HTTPForbidden,
            body: stub_response_body.to_json,
            code: 403,
            message: "HTTP Forbidden Request Error"
          )

          allow(Net::HTTPForbidden).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::ForbiddenError)
        end

        it "raise error HTTPTooManyRequests" do
          error_resp = instance_double(
            Net::HTTPTooManyRequests,
            body: stub_response_body.to_json,
            code: 429,
            message: "HTTP Many Request Error"
          )

          allow(Net::HTTPTooManyRequests).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::RateLimitingError)
        end

        it "raise error HTTPServerError" do
          error_resp = instance_double(
            Net::HTTPServerError,
            body: stub_response_body.to_json,
            code: 500,
            message: "HTTP Internal Server Error"
          )

          allow(Net::HTTPServerError).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::APIError)
        end

        it "raise error HTTPGatewayTimeout" do
          error_resp = instance_double(
            Net::HTTPGatewayTimeout,
            body: stub_response_body.to_json,
            code: 504,
            message: "HTTP Gateway Timeoutr"
          )

          allow(Net::HTTPGatewayTimeout).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::APIError)
        end

        it "raise error HTTPServiceUnavailable" do
          error_resp = instance_double(
            Net::HTTPServiceUnavailable,
            body: stub_response_body.to_json,
            code: 503,
            message: "HTTP Service Unavailable"
          )

          allow(Net::HTTPServiceUnavailable).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::APIError)
        end

        it "raise error HTTPBadGateway" do
          error_resp = instance_double(
            Net::HTTPBadGateway,
            body: stub_response_body.to_json,
            code: 502,
            message: "HTTP Bad Gateway"
          )

          allow(Net::HTTPBadGateway).to receive(:===)
            .with(error_resp)
            .and_return(true)

          expect do
            described_class.from_net_http(error_resp, request)
          end .to raise_error(MagicAdmin::APIError)
        end
      end
    end
  end
end
