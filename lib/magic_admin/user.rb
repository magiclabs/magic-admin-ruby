# frozen_string_literal: true

module MagicAdmin
  # User Class
  class User
    attr_reader :magic_client

    def initialize(magic_client)
      @magic_client = magic_client
    end

    def metadata_by_issuer(issuer)
      headers = Util.headers(magic_client.secret_key)
      options = { params: { issuer: issuer }, headers: headers }
      magic_client.http_client
                  .call(:get, "/v1/admin/auth/user/get", options)
    end

    def metadata_by_public_address(public_address)
      issuer = Token.issuer_by_public_address(public_address)
      metadata_by_issuer(issuer)
    end

    def metadata_by_did_token(did_token)
      issuer = Token.issuer_by_did_token(did_token)
      metadata_by_issuer(issuer)
    end

    def logout_by_issuer(issuer)
      headers = Util.headers(magic_client.secret_key)
      options = { params: { issuer: issuer }, headers: headers }
      magic_client.http_client
                  .call(:post, "/v2/admin/auth/user/logout", options)
    end

    def logout_by_public_address(public_address)
      issuer = Token.issuer_by_public_address(public_address)
      logout_by_issuer(issuer)
    end

    def logout_by_did_token(did_token)
      issuer = Token.issuer_by_did_token(did_token)
      logout_by_issuer(issuer)
    end
  end
end
