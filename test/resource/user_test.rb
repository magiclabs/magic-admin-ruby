# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Resource::User do
  let(:magic) { Magic.new(api_secret_key: spec_api_secret_key) }
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

  subject { described_class.new(magic) }

  it "present attr readers" do
    expect(subject).to respond_to(:magic)
  end

  context "#metadata_by_issuer" do
    it "send request with options" do
      allow(MagicAdmin::Util).to receive(:headers)
        .with(magic.secret_key)
        .and_return({})
      expect(magic.http_client).to receive(:call)
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
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += issuer_by_public_address
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.metadata_by_public_address(public_address)
      expect(reps.http_status).to eq(200)
    end
  end

  context "#metadata_by_did_token" do
    it "return response" do
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += issuer
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.metadata_by_did_token(spec_did_token)

      expect(reps.http_status).to eq(200)
    end
  end

  context "#logout_by_issuer" do
    it "return response" do
      url = "https://api.magic.link/v2/admin/auth/user/logout"
      stub_request(:post, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.logout_by_issuer(issuer)

      expect(reps.http_status).to eq(200)
    end
  end

  context "#logout_by_public_address" do
    it "return response" do
      url = "https://api.magic.link/v2/admin/auth/user/logout"
      stub_request(:post, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.logout_by_public_address(public_address)
      expect(reps.http_status).to eq(200)
    end
  end

  context "#logout_by_did_token" do
    it "return response" do
      url = "https://api.magic.link/v2/admin/auth/user/logout"
      stub_request(:post, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.logout_by_did_token(spec_did_token)
      expect(reps.http_status).to eq(200)
    end
  end
end
