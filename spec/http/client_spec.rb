# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Http::Client do
  let(:api_base) { MagicAdmin::Config.api_base }
  let(:retries) { 3 }
  let(:backoff) { 0.02 }
  let(:timeout) { 5 }
  let(:stub_response_body) do
    { "data" => {}, "error_code" => "", "message" => "", "status" => "ok" }
  end

  subject { described_class.new(api_base, retries, timeout, backoff) }

  it "present attr_reader" do
    expect(subject).to respond_to(:retries)
    expect(subject).to respond_to(:backoff)
    expect(subject).to respond_to(:timeout)
    expect(subject).to respond_to(:base_url)
    expect(subject).to respond_to(:http_request)
    expect(subject).to respond_to(:http_response)
  end

  context "#call" do
    it "calling methods" do
      stub_request(:get, "https://api.magic.link//v1/admin/auth/user/get")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      expect(subject).to receive(:backoff_retries).with(subject.retries,
                                                        subject.backoff)
      expect(subject.http_response).to receive(:from_net_http)

      subject.call(:get, "/v1/admin/auth/user/get", {})
    end
  end

  describe "private methods" do
    context "#backoff_retries" do
      describe "when raise StandardError error" do
        it "retries until attempts >= max_retries" do
          block = proc {}
          max_retries = 3

          expect(block).to receive(:call).and_raise(StandardError).exactly(max_retries).times
          expect do
            subject.send(:backoff_retries,
                         max_retries,
                         backoff,
                         &block)
          end .to raise_error(StandardError)
        end
      end
    end

    context "#use_ssl?" do
      it "return true when url schema is https" do
        expect(subject.send(:use_ssl?, double("url", scheme: "https"))).to be_truthy
      end
    end

    context "#base_client" do
      it "calling http request with arguments" do
        url = double("url", scheme: "https", host: "localhost", port: 3000)
        request = double("request", )
        read_timeout = double("read_timeout")

        expect(Net::HTTP).to receive(:start).with(url.host,
                                                  url.port,
                                                  use_ssl: true)

        subject.send(:base_client, url, request, read_timeout)
      end
    end
  end
end
