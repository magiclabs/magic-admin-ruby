# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Resource::User do
  let(:magic) { Magic.new(api_secret_key: spec_api_secret_key, client_id: spec_client_id) }
  let(:public_address) do
    MagicAdmin::Resource::Token.new(magic).get_public_address(spec_did_token)
  end

  let(:issuer) do
    MagicAdmin::Resource::Token.new(magic).get_issuer(spec_did_token)
  end

  let(:construct_issuer_with_public_address) do
    MagicAdmin::Resource::Token.new(magic).construct_issuer_with_public_address(public_address)
  end

  let(:stub_response_body) do
    { "data" => {}, "error_code" => "", "message" => "", "status" => "ok" }
  end

  subject { described_class.new(magic) }

  it "present attr readers" do
    expect(subject).to respond_to(:magic)
  end

  describe "#get_metadata_by_issuer with or without wallet" do
    before(:each) do
      allow(MagicAdmin::Util).to receive(:headers)
      .with(magic.secret_key)
      .and_return({})
    end

    context "#get_metadata_by_issuer no wallet" do
      it "send request with options" do
        expect(magic.http_client).to receive(:call)
          .with(:get,
                "/v1/admin/auth/user/get",
                {
                  params: { issuer: issuer, wallet_type: MagicAdmin::Resource::WalletType::NONE }, headers: {}
                })
        subject.get_metadata_by_issuer(issuer)
      end
    end

    context "#get_metadata_by_issuer with wallet that does not exist" do
      it "send request with options" do
        expect(magic.http_client).to receive(:call)
          .with(:get,
                "/v1/admin/auth/user/get",
                {
                  params: { issuer: issuer, wallet_type: "dne" }, headers: {}
                })
        subject.get_metadata_by_issuer(issuer, "dne")
      end
    end

    context "#get_metadata_by_issuer with wallet" do
      it "send request with options" do
        expect(magic.http_client).to receive(:call)
          .with(:get,
                "/v1/admin/auth/user/get",
                {
                  params: { issuer: issuer, wallet_type: MagicAdmin::Resource::WalletType::ALGOD }, headers: {}
                })
        subject.get_metadata_by_issuer(issuer, MagicAdmin::Resource::WalletType::ALGOD)
      end
    end
  end

  context "#get_metadata_by_public_address" do
    it "return response" do
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += construct_issuer_with_public_address
      url += "&wallet_type=" + MagicAdmin::Resource::WalletType::NONE
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.get_metadata_by_public_address(public_address)
      expect(reps.status_code).to eq(200)
    end
  end

  context "#get_metadata_by_public_address" do
    it "return response" do
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += construct_issuer_with_public_address
      url += "&wallet_type=" + MagicAdmin::Resource::WalletType::SOLANA
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.get_metadata_by_public_address(public_address, MagicAdmin::Resource::WalletType::SOLANA)
      expect(reps.status_code).to eq(200)
    end
  end

  context "#get_metadata_by_token" do
    it "return response" do
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += issuer
      url += "&wallet_type=" + MagicAdmin::Resource::WalletType::NONE
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.get_metadata_by_token(spec_did_token)

      expect(reps.status_code).to eq(200)
    end
  end

  context "#get_metadata_by_token" do
    it "return response" do
      url = "https://api.magic.link/v1/admin/auth/user/get?issuer="
      url += issuer
      url += "&wallet_type=" + MagicAdmin::Resource::WalletType::ANY
      stub_request(:get, url)
        .to_return(status: 200, body: stub_response_body.to_json, headers: {})
      reps = subject.get_metadata_by_token(spec_did_token, MagicAdmin::Resource::WalletType::ANY)

      expect(reps.status_code).to eq(200)
    end
  end

  describe "#get_metadata_by_issuer object network strategy" do
    before(:each) do
      url = "https://api.magic.link/v2/admin/auth/user/logout"
      stub_request(:post, url).to_return(status: 200, body: stub_response_body.to_json, headers: {})
    end

    context "#logout_by_issuer" do
      it "return response" do
        reps = subject.logout_by_issuer(issuer)
        expect(reps.status_code).to eq(200)
      end
    end
   
    context "#logout_by_public_address" do
      it "return response" do
        reps = subject.logout_by_public_address(public_address)
        expect(reps.status_code).to eq(200)
      end
    end

    context "#logout_by_token" do
      it "return response" do
        reps = subject.logout_by_token(spec_did_token)
        expect(reps.status_code).to eq(200)
      end
    end
  end
end
