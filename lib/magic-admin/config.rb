# frozen_string_literal: true

# MagicAdmin::Config module to access configuration info methods
module MagicAdmin
  module Config
    def self.platform
      RUBY_PLATFORM
    end

    def self.language
      "ruby"
    end

    def self.language_version
      RUBY_VERSION
    end

    def self.user_name
      Etc.getpwnam(Etc.getlogin).gecos.split(/,/).first
    end

    def self.publisher
      "MagicLabs"
    end

    def self.api_base
      "https://api.magic.link"
    end

    def self.nbf_grace_period
      300
    end
  end
end
