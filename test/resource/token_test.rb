# frozen_string_literal: true

require "spec_helper"

describe MagicAdmin::Resource::Token do
  describe "instance methods" do
    describe "public methods" do
      it "#validate" do
        claim = { "ext" => 1000, "nbf" => "nbf" }
        rec_address = double("rec_address").to_s
        proof = double("proof")
        time_now = 1_202_020
        allow(Time).to receive(:now).and_return(time_now)

        expect(subject).to receive(:decode).and_return([proof, claim])
        expect(subject).to receive(:validate_claim_fields!).with(claim)

        expect(subject).to receive(:rec_pub_address)
          .with(claim, proof)
          .and_return(rec_address)

        expect(subject).to receive(:validate_public_address!)
          .with(rec_address, spec_did_token)

        expect(subject).to receive(:validate_claim_ext!)
          .with(time_now, claim["ext"])

        expect(subject).to receive(:validate_claim_nbf!)
          .with(time_now, claim["nbf"])

        subject.validate(spec_did_token)
      end

      context "#decode" do
        it "with valid token" do
          clam_hash = {
            "iat" => 1_234_512_345,
            "ext" => 1_234_512_345,
            "iss" => "did:ethr:0xtest0000test0000test0000test0000test0000",
            "sub" => "00abcdefghijklmnopqrstuvwxyz123456789000000=",
            "aud" => "did:magic:testtest-test-test-test-testtesttest",
            "nbf" => 1_234_512_345,
            "tid" => "testtest-test-test-test-testtesttest",
            "add" => "0x00test0000test0000test0000test0000test0000"\
                     "test0000test0000test0000test0000test0000test"\
                     "0000test0000test0000test0000test0000test0000"
          }

          proof_str = "0xtest0000test0000test0000test0000test0000"\
                      "test0000test0000test0000test0000test0000test"\
                      "0000test0000test0000test0000test0000test000000"

          decode_val = [proof_str, clam_hash]

          expect(subject.decode(spec_did_token)).to eq(decode_val)
        end

        it "with invalid token" do
          allow(subject).to receive(:base64_decode)
            .with(spec_did_token)
            .and_return("")

          expect do
            subject.decode(spec_did_token)
          end .to raise_error(MagicAdmin::DIDTokenError,
                              "DID Token is malformed")
        end
      end

      context "#construct_issuer_with_public_address" do
        it "return format" do
          public_address = subject.construct_issuer_with_public_address("test_address")
          expected = "did:ethr:test_address"
          expect(public_address).to eq(expected)
        end
      end

      context "#get_issuer" do
        it "return format" do
          issuer = subject.get_issuer(spec_did_token)
          expected = "did:ethr:0xtest0000test0000test0000test0000test0000"
          expect(issuer).to eq(expected)
        end
      end

      context "#get_public_address" do
        it "return format" do
          public_address = subject.get_public_address(spec_did_token)
          expected = "0xtest0000test0000test0000test0000test0000"
          expect(public_address).to eq(expected)
        end
      end
    end

    describe "private methods" do
      it "#claim_fields" do
        fields = subject.send(:claim_fields)
        expect(fields).to eq(%w[iat ext iss sub aud nbf tid])
      end

      context "#validate_claim_fields!" do
        it "return true when claim keys match with claim_fields " do
          allow(subject).to receive(:claim_fields).and_return([])

          expect(subject.send(:validate_claim_fields!, {})).to be_truthy
        end

        it "raise error when claim keys does not match with claim_fields " do
          fields = %w[iat ext iss sub aud nbf tid]
          msg = "DID Token missing required fields: "
          msg += fields.join(", ")
          expect do
            subject.send(:validate_claim_fields!, { invalid: nil })
          end .to raise_error(MagicAdmin::DIDTokenError, msg)
        end
      end

      context "#validate_public_address!" do
        it "return true when rec_address eq did_token public_address" do
          allow(subject).to receive(:get_public_address)
            .with(spec_did_token)
            .and_return("test_123")

          expect(subject.send(:validate_public_address!,
                              "test_123",
                              spec_did_token)).to be_truthy
        end

        it "raise error when rec_address not eq did_token public_address" do
          msg = "Signature mismatch between 'proof' and 'claim'."
          expect do
            subject.send(:validate_public_address!,
                         "test_123",
                         spec_did_token)
          end .to raise_error(MagicAdmin::DIDTokenError, msg)
        end
      end

      context "#validate_claim_ext!" do
        it "return true when time is not grater claim_ext" do
          time = Time.now.to_i
          claim_ext = time + 100

          expect(subject.send(:validate_claim_ext!,
                              time,
                              claim_ext)).to be_truthy
        end

        it "raise error when time is grater claim_ext" do
          time = Time.now.to_i
          claim_ext = time - 100
          msg = "Given DID token has expired. Please generate a new one."
          expect do
            subject.send(:validate_claim_ext!, time, claim_ext)
          end .to raise_error(MagicAdmin::DIDTokenError, msg)
        end
      end

      context "#validate_claim_nbf using apply_nbf_grace_period claim_nbf" do
        it "when time is not less then return true" do
          time = Time.now.to_i
          claim_nbf = double("claim_nbf")
          allow(subject).to receive(:apply_nbf_grace_period)
            .with(claim_nbf)
            .and_return(time - 100)

          expect(subject.send(:validate_claim_nbf!,
                              time,
                              claim_nbf)).to be_truthy
        end

        it "when time is less then raise error" do
          time = Time.now.to_i
          claim_nbf = double("claim_nbf")
          msg = "Given DID token cannot be used at this time."
          allow(subject).to receive(:apply_nbf_grace_period)
            .with(claim_nbf)
            .and_return(time + 100)

          expect do
            subject.send(:validate_claim_nbf!, time, claim_nbf)
          end .to raise_error(MagicAdmin::DIDTokenError, msg)
        end
      end
    end
  end
end
