# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Resource::User do
  let(:magic_client) { Magic.new(api_secret_key: spec_api_secret_key) }
  let(:public_address) do
    MagicAdmin::Resource::Token.new.public_address(spec_did_token)
  end

  let(:issuer) do
    MagicAdmin::Resource::Token.new.issuer_by_did_token(spec_did_token)
  end

  let(:issuer_by_public_address) do
    MagicAdmin::Resource::Token.new.issuer_by_public_address(public_address)
  end

  let(:stub_response_body) do
    { "data" => {}, "error_code" => "", "message" => "", "status" => "ok" }
  end

  subject { described_class.new(magic_client) }

  it "present attr readers" do
    expect(subject).to respond_to(:magic_client)
  end

  context "#metadata_by_issuer" do
    it "send request with options" do
      allow(MagicAdmin::Util).to receive(:headers)
        .with(magic_client.secret_key)
        .and_return({})
      expect(magic_client.http_client).to receive(:call)
        .with(:get,
              "/v1/admin/auth/user/get",
              {
                params: { issuer: issuer }, headers: {}
              })

      subject.metadata_by_issuer(issuer)
    end
  end

  context "#metadata_by_public_address" do
    it "return response" do
      stub_request(:get, "https://api.magic.link/v1/admin/auth/user/get?issuer=#{issuer_by_public_address}")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})

      expect(subject.metadata_by_public_address(public_address).http_status).to eq(200)
    end
  end

  context "#metadata_by_did_token" do
    it "return response" do
      stub_request(:get, "https://api.magic.link/v1/admin/auth/user/get?issuer=#{issuer}")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})

      expect(subject.metadata_by_did_token(spec_did_token).http_status).to eq(200)
    end
  end

  context "#logout_by_issuer" do
    it "return response" do
      stub_request(:post, "https://api.magic.link/v2/admin/auth/user/logout")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})

      expect(subject.logout_by_issuer(issuer).http_status).to eq(200)
    end
  end

  context "#logout_by_public_address" do
    it "return response" do
      stub_request(:post, "https://api.magic.link/v2/admin/auth/user/logout")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})

      expect(subject.logout_by_public_address(public_address).http_status).to eq(200)
    end
  end

  context "#logout_by_did_token" do
    it "return response" do
      stub_request(:post, "https://api.magic.link/v2/admin/auth/user/logout")
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})

      expect(subject.logout_by_did_token(spec_did_token).http_status).to eq(200)
    end
  end
end
