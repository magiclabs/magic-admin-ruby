# frozen_string_literal: true

module MagicAdmin
  module Resource
    # The user resource and its methods are accessible
    # on the Magic instance by the User attribute.
    # It provides methods to interact with the User.
    class User
      # attribute reader for magic client object
      attr_reader :magic

      # The constructor allows you to create user object
      # when your application interacting with the Magic API
      #
      # Arguments:
      #   magic: magic object.
      #
      # Returns:
      #   A user object that provides access to all the supported resources.
      #
      # Examples:
      #   User.new(<magic>)
      #

      def initialize(magic)
        @magic = magic
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied issuer
      #
      # Arguments:
      #   issuer: extracted iss component of DID Token
      #   generated by a Magic user on the client-side.
      #   token  = Token.new
      #   issuer = token.issuer_by_did_token(<did_token>).
      #
      # Returns:
      #   Metadata information about the user
      #

      def metadata_by_issuer(issuer)
        headers = MagicAdmin::Util.headers(magic.secret_key)
        options = { params: { issuer: issuer }, headers: headers }
        magic.http_client
             .call(:get, "/v1/admin/auth/user/get", options)
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied public_address
      #
      # Arguments:
      #   public_address: extracted The user's Ethereum public address component
      #   of DID Token generated by a Magic user on the client-side.
      #   token  = Token.new
      #   public_address = token.public_address(<did_token>).
      #
      # Returns:
      #   Metadata information about the user
      #

      def metadata_by_public_address(public_address)
        issuer = token.issuer_by_public_address(public_address)
        metadata_by_issuer(issuer)
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied DID Token
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   Metadata information about the user
      #

      def metadata_by_did_token(did_token)
        issuer = token.issuer_by_did_token(did_token)
        metadata_by_issuer(issuer)
      end

      # Description:
      #   Method logs a user out of all Magic SDK sessions by
      #   the supplied issuer
      #
      # Arguments:
      #   issuer: extracted iss component of DID Token
      #   generated by a Magic user on the client-side.
      #   token  = Token.new
      #   issuer = token.issuer_by_did_token(<did_token>).
      #
      # Returns:
      #   Magic Response
      #

      def logout_by_issuer(issuer)
        headers = MagicAdmin::Util.headers(magic.secret_key)
        options = { params: { issuer: issuer }, headers: headers }
        magic.http_client
             .call(:post, "/v2/admin/auth/user/logout", options)
      end

      # Description:
      #   Method logs a user out of all Magic SDK sessions by
      #   the supplied public_address
      #
      # Arguments:
      #   public_address: extracted The user's Ethereum public address component
      #   of DID Token generated by a Magic user on the client-side.
      #   token  = Token.new
      #   public_address = token.public_address(<did_token>).
      #
      # Returns:
      #   Magic Response
      #

      def logout_by_public_address(public_address)
        issuer = token.issuer_by_public_address(public_address)
        logout_by_issuer(issuer)
      end

      # Description:
      #   Method logs a user out of all Magic SDK sessions by
      #   the supplied DID Token
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      #
      # Returns:
      #   Magic Response
      #

      def logout_by_token(did_token)
        issuer = token.issuer_by_did_token(did_token)
        logout_by_issuer(issuer)
      end

      private

      def token
        magic.token
      end
    end
  end
end
