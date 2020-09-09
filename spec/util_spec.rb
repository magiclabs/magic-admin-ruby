# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Util, type: :module do
  context ".platform_info" do
    it "return respond" do
      expect(described_class.platform_info).to be_kind_of(Hash)
    end

    it "include keys" do
      expect(described_class.platform_info).to include(:platform,
                                                       :language,
                                                       :language_version,
                                                       :user_name)
    end
  end

  context ".user_agent" do
    it "return respond" do
      expect(described_class.user_agent).to be_kind_of(Hash)
    end

    it "include keys" do
      expect(described_class.user_agent).to include(:sdk_version,
                                                    :publisher,
                                                    :platform)
    end
  end

  context ".headers" do
    it "return respond" do
      expect(described_class.headers(spec_api_secret_key)).to be_kind_of(Hash)
    end

    it "include keys" do
      expect(described_class.headers(spec_api_secret_key)).to include(
        :"content-type", :"X-Magic-Secret-Key", :"User-Agent"
      )
    end
  end
end
