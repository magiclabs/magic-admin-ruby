# frozen_string_literal: true

require "spec_helper"

describe Magic do
  let(:env_secret_key) { "<ENV_MAGIC_API_SECRET_KEY>" }
  let(:arg_secret_key) { "<ARG_MAGIC_API_SECRET_KEY>" }

  let(:env_client_id) { "<ENV_MAGIC_CLIENT_ID>" }
  let(:arg_client_id) { "<ARG_MAGIC_CLIENT_ID>" }
  let(:returned_client_id) { "<RETURNED_CLIENT_ID>" }

  before(:each) do
    allow_any_instance_of(MagicAdmin::Http::Client).to receive(:call).and_return(
      double(data: { data: { client_id: returned_client_id } })
    )
  end

  describe "magic object without arguments and environment variables" do
    it "should raise an error" do
      expect { Magic.new }.to raise_exception MagicAdmin::MagicError
    end
  end

  describe "magic object set secret_key" do
    it "should be set with environment variable" do
      ENV["MAGIC_API_SECRET_KEY"] = env_secret_key
      magic = Magic.new
      expect(magic.secret_key).to eq(env_secret_key)
    end

    it "should be set with arguments" do
      magic = Magic.new(api_secret_key: arg_secret_key)
      expect(magic.secret_key).to eq(arg_secret_key)
    end

    it "should be set with arguments ignore environment variable" do
      ENV["MAGIC_API_SECRET_KEY"] = env_secret_key
      magic = Magic.new(api_secret_key: arg_secret_key)
      expect(magic.secret_key).to eq(arg_secret_key)
      expect(magic.secret_key).not_to eq(env_secret_key)
    end
  end

  describe "magic object network strategy" do
    before(:each) do
      ENV["MAGIC_API_SECRET_KEY"] = spec_api_secret_key
    end

    describe "set retries" do
      let(:default_retries) { 3 }
      let(:env_retries) { "4" }
      let(:arg_retries) { 5 }

      it "should be set with default values" do
        http_client = Magic.new.http_client
        expect(http_client.retries).to eq(default_retries)
      end

      it "should be set with environment variable" do
        ENV["MAGIC_API_RETRIES"] = env_retries
        http_client = Magic.new.http_client
        expect(http_client.retries).to eq(env_retries.to_f)
      end

      it "should be set with argument" do
        http_client = Magic.new(retries: arg_retries).http_client
        expect(http_client.retries).to eq(arg_retries)
      end

      it "should be set with argument ignore environment variable" do
        ENV["MAGIC_API_RETRIES"] = env_retries
        http_client = Magic.new(retries: arg_retries).http_client
        expect(http_client.retries).to eq(arg_retries)
      end
    end

    describe "set timeout" do
      let(:default_timeout) { 5 }
      let(:env_timeout) { "6" }
      let(:arg_timeout) { 7 }

      it "should be set with default values" do
        http_client = Magic.new.http_client
        expect(http_client.timeout).to eq(default_timeout)
      end

      it "should be set with environment variable" do
        ENV["MAGIC_API_TIMEOUT"] = env_timeout
        http_client = Magic.new.http_client
        expect(http_client.timeout).to eq(env_timeout.to_f)
      end

      it "should be set with argument" do
        http_client = Magic.new(timeout: arg_timeout).http_client
        expect(http_client.timeout).to eq(arg_timeout)
      end

      it "should be set with argument ignore environment variable" do
        ENV["MAGIC_API_TIMEOUT"] = env_timeout
        http_client = Magic.new(timeout: arg_timeout).http_client
        expect(http_client.timeout).to eq(arg_timeout)
      end
    end

    describe "set backoff" do
      let(:default_backoff) { 0.02 }
      let(:env_backoff) { "0.03" }
      let(:arg_backoff) { 0.04 }

      it "should be set with default values" do
        http_client = Magic.new.http_client
        expect(http_client.backoff).to eq(default_backoff)
      end

      it "should be set with environment variable" do
        ENV["MAGIC_API_BACKOFF"] = env_backoff
        http_client = Magic.new.http_client
        expect(http_client.backoff).to eq(env_backoff.to_f)
      end

      it "should be set with argument" do
        http_client = Magic.new(backoff: arg_backoff).http_client
        expect(http_client.backoff).to eq(arg_backoff)
      end

      it "should be set with argument ignore environment variable" do
        ENV["MAGIC_API_BACKOFF"] = env_backoff
        http_client = Magic.new(backoff: arg_backoff).http_client
        expect(http_client.backoff).to eq(arg_backoff)
      end
    end
  end

  describe "magic object set client_id" do

    let(:api_secret_key) { "<API_SECRET_KEY>" }
    
    before(:each) do
      ENV["MAGIC_API_SECRET_KEY"] = api_secret_key
    end

    it "should be set with environment variable" do
      ENV["MAGIC_CLIENT_ID"] = env_client_id
      magic = Magic.new
      expect(magic.client_id).to eq(env_client_id)
    end

    it "should be set with argument" do
      ENV["MAGIC_CLIENT_ID"] = nil
      magic = Magic.new(client_id: arg_client_id)
      expect(magic.client_id).to eq(arg_client_id)
    end

    it "should be set with argument ignore environment variable" do
      ENV["MAGIC_CLIENT_ID"] = env_client_id
      magic = Magic.new(client_id: arg_client_id)
      expect(magic.client_id).to eq(arg_client_id)
      expect(magic.client_id).not_to eq(env_client_id)
    end

    it "should retrieve from API if not set" do
      ENV["MAGIC_CLIENT_ID"] = nil
      magic = Magic.new
      expect(magic.client_id).to eq(returned_client_id)
    end

    it "should raise an error if API key is invalid" do
      allow_any_instance_of(MagicAdmin::Http::Client).to receive(:call).and_return(
        double(data: { data: { } })
      )
      expect { Magic.new }.to raise_exception MagicAdmin::MagicError
    end
  end
end
