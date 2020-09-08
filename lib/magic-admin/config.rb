# frozen_string_literal: true

# MagicAdmin::Config module to access configuration info methods
module MagicAdmin
  module Config
    # Description:
    #   Method provides you platform information
    #
    # Returns:
    #   user platform information
    #

    def self.platform
      RUBY_PLATFORM
    end

    # Description:
    #   Method provides you sdk programming language
    #
    # Returns:
    #   sdk programming language
    #

    def self.language
      "ruby"
    end

    # Description:
    #   Method provides you sdk programming language version
    #
    # Returns:
    #   sdk programming language version
    #

    def self.language_version
      RUBY_VERSION
    end

    # Description:
    #   Method provides you installation machine user_name
    #
    # Returns:
    #   installation machine user_name
    #

    def self.user_name
      Etc.getpwnam(Etc.getlogin).gecos.split(/,/).first
    end

    # Description:
    #   Method provides you sdk publisher name
    #
    # Returns:
    #   sdk publisher name
    #

    def self.publisher
      "MagicLabs"
    end

    # Description:
    #   Method provides you api base url
    #
    # Returns:
    #   api base url
    #

    def self.api_base
      "https://api.magic.link"
    end

    # Description:
    #   Method provides you nbf grace period
    #
    # Returns:
    #   nbf grace period
    #

    def self.nbf_grace_period
      300
    end
  end
end
