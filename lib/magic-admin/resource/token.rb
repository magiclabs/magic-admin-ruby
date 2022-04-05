# frozen_string_literal: true

module MagicAdmin

  module Resource

    # The token resource and its methods are accessible
    # on the Magic instance by the Token attribute.
    # It provides methods to interact with the DID Token.
    class Token

      # Description:
      #   Method validate did_token
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   true or raise an error
      def validate(did_token)
        time = Time.now.to_i
        proof, claim = decode(did_token)
        rec_address = rec_pub_address(claim, proof).to_s

        validate_public_address!(rec_address, did_token)
        validate_claim_fields!(claim)
        validate_claim_ext!(time, claim["ext"])
        validate_claim_nbf!(time, claim["nbf"])
      end

      # Description:
      #   Method Decodes a DID Token from a Base64 string into
      #   a tuple of its individual components: proof and claim.
      #   This method allows you decode the DID Token
      #   and inspect the token
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   An array containing proof and claim or raise an error
      def decode(did_token)
        proof = nil
        claim = nil
        begin
          token_array = JSON.parse(base64_decode(did_token))
          proof = token_array[0]
          claim = JSON.parse(token_array[1])
          validate_claim_fields!(claim)
        rescue JSON::ParserError, ArgumentError
          raise DIDTokenError, "DID Token is malformed"
        end
        [proof, claim]
      end

      # Description:
      #   Method parse public_address and extract issuer
      #
      # Arguments:
      #   public_address: Cryptographic public address of the Magic User.
      #
      # Returns:
      #   issuer info
      def construct_issuer_with_public_address(public_address)
        "did:ethr:#{public_address}"
      end

      # Description:
      #   Method parse did_token and extract issuer
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   issuer info
      def get_issuer(did_token)
        decode(did_token).last["iss"]
      end

      # Description:
      #   Method parse did_token and extract  cryptographic public_address
      #
      # Arguments:
      #   did_token: A DID Token generated by a Magic user on the client-side.
      #
      # Returns:
      #   cryptographic public address of the Magic User
      #   who generated the supplied DID Token.
      def get_public_address(did_token)
        get_issuer(did_token).split(":").last
      end

      private

      def base64_decode(did_token)
        Base64.urlsafe_decode64(did_token)
      end

      def personal_recover(claim, proof)
        Eth::Signature.personal_recover(JSON.dump(claim), proof)
      end

      def rec_pub_address(claim, proof)
        Eth::Util.public_key_to_address personal_recover(claim, proof)
      end

      def claim_fields
        %w[iat ext iss sub aud nbf tid]
      end

      def validate_claim_fields!(claim)
        missing_fields = claim_fields - claim.keys
        return true unless missing_fields.any?

        message = "DID Token missing required fields: %s"
        raise DIDTokenError, message % missing_fields.join(", ")
      end

      def validate_public_address!(rec_address, did_token)
        return true if rec_address.eql? get_public_address(did_token)

        message = "Signature mismatch between 'proof' and 'claim'."
        raise DIDTokenError, message
      end

      def validate_claim_ext!(time, claim_ext)
        return true unless time > claim_ext

        message = "Given DID token has expired. Please generate a new one."
        raise DIDTokenError, message
      end

      def apply_nbf_grace_period(claim_nbf)
        claim_nbf - MagicAdmin::Config.nbf_grace_period
      end

      def validate_claim_nbf!(time, claim_nbf)
        return true unless time < apply_nbf_grace_period(claim_nbf)

        message = "Given DID token cannot be used at this time."
        raise DIDTokenError, message
      end

    end
  end
end
