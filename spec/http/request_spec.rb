# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Http::Request do
  let(:url) { URI("https://api.magic.link/v1/admin/auth/user/get") }
  let(:options) { {} }
  describe "class methods" do
    context ".request" do
      it "raise error when method is not [GET POST]" do
        expect do
          described_class.request(:put,
                                  url,
                                  options)
        end .to raise_error(MagicAdmin::APIError,
                            "Request method not supported.")
      end

      it "when method is GET" do
        expect_any_instance_of(described_class).to receive(:get).with(url,
                                                                      options)

        described_class.request(:get, url, options)
      end

      it "when method is POST" do
        expect_any_instance_of(described_class).to receive(:post).with(url,
                                                                       options)

        described_class.request(:post, url, options)
      end
    end
  end

  context "#get" do
    it "return response" do
      expect(subject.get(url, options)).to be_instance_of(Net::HTTP::Get)
      expect(subject.get(url,
                         options).uri.to_s).to eq("https://api.magic.link/v1/admin/auth/user/get?")
    end
  end

  context "#post" do
    it "return response" do
      expect(subject.post(url, options)).to be_instance_of(Net::HTTP::Post)
      expect(subject.post(url,
                          options).uri.to_s).to eq("https://api.magic.link/v1/admin/auth/user/get")
    end
  end
end
