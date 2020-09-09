# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Http::Response do
  let(:stub_response_body) do
    { "data" => {}, "error_code" => "", "message" => "", "status" => "ok" }
  end

  let(:http_resp) do
    double("http_resp",
           body: stub_response_body.to_json,
           code: 200,
           message: "ok")
  end

  let(:url) { URI("https://api.magic.link//v1/admin/auth/user/get") }
  let(:request) { MagicAdmin::Http::Request.request(:get, url, {}) }

  subject { described_class.new(http_resp) }

  it "present attr_reader" do
    expect(subject).to respond_to(:json_data)
    expect(subject).to respond_to(:http_body)
    expect(subject).to respond_to(:http_status)
    expect(subject).to respond_to(:message)
  end

  context "#error_opt" do
    it "return response" do
      expect(subject.error_opt(request)).to include(:http_status,
                                                    :http_code,
                                                    :http_response,
                                                    :http_message,
                                                    :http_error_code,
                                                    :http_request_params,
                                                    :http_request_header,
                                                    :http_method)
    end
  end

  describe "class_methods" do
    context ".from_net_http" do
      it "with valid request" do
        expect(described_class.from_net_http(http_resp,
                                             request)).to be_instance_of(MagicAdmin::Http::Response)
        expect(described_class.from_net_http(http_resp,
                                             request).http_status).to eq(200)
      end

      context "with invalid request" do
        it "raise error BadRequestError" do
          error_resp = instance_double(Net::HTTPBadRequest,
                                       body: stub_response_body.to_json,
                                       code: 400,
                                       message: "HTTP Bad Request")
          allow(Net::HTTPBadRequest).to receive(:===).with(error_resp).and_return(true)

          expect do
            described_class.from_net_http(error_resp,
                                          request)
          end .to raise_error(MagicAdmin::BadRequestError)
        end

        it "raise error HTTPUnauthorized" do
          error_resp = instance_double(Net::HTTPUnauthorized,
                                       body: stub_response_body.to_json,
                                       code: 401,
                                       message: "HTTP Unauthorized  Request Error")
          allow(Net::HTTPUnauthorized).to receive(:===).with(error_resp).and_return(true)

          expect do
            described_class.from_net_http(error_resp,
                                          request)
          end .to raise_error(MagicAdmin::UnauthorizedError)
        end

        it "raise error HTTPForbidden" do
          error_resp = instance_double(Net::HTTPForbidden,
                                       body: stub_response_body.to_json,
                                       code: 403,
                                       message: "HTTP Forbidden Request Error")
          allow(Net::HTTPForbidden).to receive(:===).with(error_resp).and_return(true)

          expect do
            described_class.from_net_http(error_resp,
                                          request)
          end .to raise_error(MagicAdmin::ForbiddenError)
        end

        it "raise error HTTPTooManyRequests" do
          error_resp = instance_double(Net::HTTPTooManyRequests,
                                       body: stub_response_body.to_json,
                                       code: 429,
                                       message: "HTTP Many  Request Error")
          allow(Net::HTTPTooManyRequests).to receive(:===).with(error_resp).and_return(true)

          expect do
            described_class.from_net_http(error_resp,
                                          request)
          end .to raise_error(MagicAdmin::TooManyRequestsError)
        end
      end
    end
  end
end
