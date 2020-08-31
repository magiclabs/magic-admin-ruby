# frozen_string_literal: true

module MagicAdmin
  # Token Class
  class Token
    class << self
      def validate(did_token)
        time = Time.now.to_i
        proof, claim = decode(did_token)
        rec_address = rec_pub_address(claim, proof)

        validate_public_address!(rec_address, did_token)
        validate_claim_fields!(claim)
        validate_claim_ext!(time, claim["ext"])
        validate_claim_nbf!(time, claim["nbf"])
      end

      def decode(did_token)
        proof = nil
        claim = nil
        begin
          token_array = JSON.parse(base64_decode(did_token))
          proof = token_array[0]
          claim = JSON.parse(token_array[1])
          validate_claim_fields!(claim)
        rescue JSON::ParserError
          raise DIDTokenError, "DID Token is malformed"
        end
        [proof, claim]
      end

      def issuer_by_public_address(public_address)
        "did:ethr:#{public_address}"
      end

      def issuer_by_did_token(did_token)
        decode(did_token).last["iss"]
      end

      def public_address(did_token)
        issuer_by_did_token(did_token).split(":").last
      end

      private

      def base64_decode(did_token)
        Base64.urlsafe_decode64(did_token)
      end

      def personal_recover(claim, proof)
        Eth::Key.personal_recover(JSON.dump(claim), proof)
      end

      def rec_pub_address(claim, proof)
        Eth::Utils.public_key_to_address personal_recover(claim, proof)
      end

      def claim_fields
        %w[iat ext nbf iss sub aud tid add]
      end

      def validate_claim_fields!(claim)
        missing_fields = claim_fields - claim.keys
        return true unless missing_fields.any?

        message = "DID Token is malformed"
        raise DIDTokenError, message
      end

      def validate_public_address!(rec_address, did_token)
        return true if rec_address.eql? public_address(did_token)

        message = "Signature mismatch between 'proof' and 'claim'."
        raise DIDTokenError, message
      end

      def validate_claim_ext!(time, claim_ext)
        return true unless time > claim_ext

        message = "Given DID token has expired. Please generate a new one."
        raise DIDTokenError, message
      end

      def validate_claim_nbf!(time, claim_nbf)
        return true unless time < claim_nbf

        message = "Given DID token cannot be used at this time."
        raise DIDTokenError, message
      end
    end
  end
end
