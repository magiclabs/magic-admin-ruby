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
      #   magic: A Magic object.
      #
      # Returns:
      #   A user object that provides access to all the supported resources.
      #
      # Examples:
      #   User.new(<magic>)
      def initialize(magic)
        @magic = magic
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied issuer
      #
      # Arguments:
      #   issuer: Extracted iss component of DID Token generated by a Magic user
      #     on the client-side.
      #   wallet_type: The type of wallet to retrieve.  To query specific wallet(s),
      #     the value passed must be consistent with the enumerated values in
      #     MagicAdmin::Resource::WalletType. ALL wallets will be returned if wallet_type=ANY
      #     is passed. If the wallet_type is None or does not match any WalletType
      #     enums, then no wallets are returned.
      #
      # Returns:
      #   Metadata information about the user
      def get_metadata_by_issuer(issuer, wallet_type=MagicAdmin::Resource::WalletType::NONE)
        headers = MagicAdmin::Util.headers(magic.secret_key)
        options = { params: { issuer: issuer , wallet_type: wallet_type }, headers: headers }
        magic.http_client
             .call(:get, "/v1/admin/auth/user/get", options)
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied public_address and wallet type
      #
      # Arguments:
      #   public_address: Extracted The user's Ethereum public address component
      #     of DID Token generated by a Magic user on the client-side.
      #   wallet_type: The type of wallet to retrieve.  To query specific wallet(s), 
      #     the value passed must be consistent with the enumerated values in 
      #     MagicAdmin::Resource::WalletType. ALL wallets will be returned if wallet_type=ANY
      #     is passed. If the wallet_type is None or does not match any WalletType 
      #     enums, then no wallets are returned.
      #
      # Returns:
      #   Metadata information about the user
      def get_metadata_by_public_address(public_address, wallet_type=MagicAdmin::Resource::WalletType::NONE)
        issuer = token.construct_issuer_with_public_address(public_address)
        get_metadata_by_issuer(issuer, wallet_type)
      end

      # Description:
      #   Method Retrieves information about the user by
      #   the supplied DID Token and wallet type
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #   wallet_type: The type of wallet to retrieve.  To query specific wallet(s), 
      #     the value passed must be consistent with the enumerated values in 
      #     MagicAdmin::Resource::WalletType. ALL wallets will be returned if wallet_type=ANY
      #     is passed. If the wallet_type is None or does not match any WalletType 
      #     enums, then no wallets are returned.
      #
      # Returns:
      #   Metadata information about the user
      def get_metadata_by_token(did_token, wallet_type=MagicAdmin::Resource::WalletType::NONE)
        issuer = token.get_issuer(did_token)
        get_metadata_by_issuer(issuer, wallet_type)
      end

      # Description:
      #   Method logs a user out of all Magic SDK sessions by
      #   the supplied issuer
      #
      # Arguments:
      #   issuer: Extracted iss component of DID Token generated by a Magic user
      #     on the client-side.
      #
      # Returns:
      #   Magic Response
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
      #   public_address: Extracted the user's Ethereum public address component
      #   of DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   Magic Response
      def logout_by_public_address(public_address)
        issuer = token.construct_issuer_with_public_address(public_address)
        logout_by_issuer(issuer)
      end

      # Description:
      #   Method logs a user out of all Magic SDK sessions by
      #   the supplied DID Token
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   Magic Response
      def logout_by_token(did_token)
        issuer = token.get_issuer(did_token)
        logout_by_issuer(issuer)
      end

      private

      def token
        magic.token
      end

    end
  end
end
