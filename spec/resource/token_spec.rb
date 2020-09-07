# frozen_string_literal: true

require 'spec_helper'

describe MagicAdmin::Resource::Token do
  let(:decoded_did_token) { Magic.new(api_secret_key: spec_api_secret_key) }

  describe 'instance methods' do
    describe 'public methods' do
      it '#validate' do
        claim = { 'ext' => 1000, 'nbf' => 'nbf' }
        rec_address = double('rec_address')
        proof = double('proof')
        time_now = 1_202_020
        allow(Time).to receive(:now).and_return(time_now)

        expect(subject).to receive(:decode).and_return([proof, claim])
        expect(subject).to receive(:rec_pub_address).with(claim,
                                                          proof).and_return(rec_address)
        expect(subject).to receive(:validate_public_address!).with(
          rec_address, spec_did_token
        )
        expect(subject).to receive(:validate_claim_fields!).with(claim)
        expect(subject).to receive(:validate_claim_ext!).with(time_now,
                                                              claim['ext'])
        expect(subject).to receive(:validate_claim_nbf!).with(time_now,
                                                              claim['nbf'])

        subject.validate(spec_did_token)
      end

      context '#decode' do
        it 'with valid token' do
          expect(subject.decode(spec_did_token)).to eq([
                                                         '0x7f634e8853b40b96a13b3a26770b7e8c58051cd9245ce9a8b863033bc200558751473e2eb8c5ec8aacdf4028052e4a61a6ac285196996ec2ff6f86a7881a7f951c', {
                                                           'iat' => 1_599_149_991, 'ext' => 1_599_150_891, 'iss' => 'did:ethr:0x8580De53bA37B4205CdD0286D033592fCFfce0A6', 'sub' => 'wSDilvMIsxZvqP6EwIXyde-n7gjlq58TG-OnuTczNrk=', 'aud' => 'did:magic:79f22edb-dace-4019-ae7a-ece6ed0a01a4', 'nbf' => 1_599_149_991, 'tid' => '35a27161-14a2-42c7-9f9b-ebaa77048ccd', 'add' => '0xa5f77a05a1f40f1d07bc908185ebd31e5681e8568c32b033561053b9ce982a1603373cd528c1d5cdace59035cb8f2a8b159cc7b5dbbf8309220737b35eba3ee91b'
                                                         }
                                                       ])
        end

        it 'with invalid token' do
          allow(subject).to receive(:base64_decode).with(spec_did_token).and_return('')

          expect do
            subject.decode(spec_did_token)
          end .to raise_error(MagicAdmin::DIDTokenError,
                              'DID Token is malformed')
        end
      end

      context '#issuer_by_public_address' do
        it 'return format' do
          expect(subject.issuer_by_public_address('test_address')).to eq('did:ethr:test_address')
        end
      end

      context '#issuer_by_did_token' do
        it 'return format' do
          expect(subject.issuer_by_did_token(spec_did_token)).to eq('did:ethr:0x8580De53bA37B4205CdD0286D033592fCFfce0A6')
        end
      end

      context '#public_address' do
        it 'return format' do
          expect(subject.public_address(spec_did_token)).to eq('0x8580De53bA37B4205CdD0286D033592fCFfce0A6')
        end
      end
    end

    describe 'private methods' do
      it '#claim_fields' do
        expect(subject.send(:claim_fields)).to eq(%w[iat ext iss sub aud nbf
                                                     tid])
      end

      context '#validate_claim_fields!' do
        it 'return true when claim keys match with claim_fields ' do
          allow(subject).to receive(:claim_fields).and_return([])

          expect(subject.send(:validate_claim_fields!, {})).to be_truthy
        end

        it 'raise error when claim keys does not match with claim_fields ' do
          expect do
            subject.send(:validate_claim_fields!,
                         { invalid: nil })
          end .to raise_error(MagicAdmin::DIDTokenError,
                              'DID Token missing required fields: iat, ext, iss, sub, aud, nbf, tid')
        end
      end

      context '#validate_public_address!' do
        it 'return true when rec_address eq did_token public_address' do
          allow(subject).to receive(:public_address).with(spec_did_token).and_return('test_123')

          expect(subject.send(:validate_public_address!, 'test_123',
                              spec_did_token)).to be_truthy
        end

        it 'raise error when rec_address not eq did_token public_address' do
          expect do
            subject.send(:validate_public_address!, 'test_123',
                         spec_did_token)
          end .to raise_error(MagicAdmin::DIDTokenError,
                              "Signature mismatch between 'proof' and 'claim'.")
        end
      end

      context '#validate_claim_ext!' do
        it 'return true when time is not grater claim_ext' do
          time = Time.now.to_i
          claim_ext = time + 100

          expect(subject.send(:validate_claim_ext!, time,
                              claim_ext)).to be_truthy
        end

        it 'raise error when time is grater claim_ext' do
          time = Time.now.to_i
          claim_ext = time - 100

          expect do
            subject.send(:validate_claim_ext!, time,
                         claim_ext)
          end .to raise_error(MagicAdmin::DIDTokenError,
                              'Given DID token has expired. Please generate a new one.')
        end
      end

      context '#validate_claim_nbf' do
        it 'return true when time is not less then apply_nbf_grace_period claim_nbf' do
          time = Time.now.to_i
          claim_nbf = double('claim_nbf')
          allow(subject).to receive(:apply_nbf_grace_period).with(claim_nbf).and_return(time - 100)

          expect(subject.send(:validate_claim_nbf!, time,
                              claim_nbf)).to be_truthy
        end

        it 'raise error when time is less then apply_nbf_grace_period claim_nbf' do
          time = Time.now.to_i
          claim_nbf = double('claim_nbf')
          allow(subject).to receive(:apply_nbf_grace_period).with(claim_nbf).and_return(time + 100)

          expect do
            subject.send(:validate_claim_nbf!, time,
                         claim_nbf)
          end .to raise_error(MagicAdmin::DIDTokenError,
                              'Given DID token cannot be used at this time.')
        end
      end
    end
  end
end
