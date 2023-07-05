# frozen_string_literal: true

require "bundler/setup"
Bundler.setup

require 'simplecov'
SimpleCov.start

require "magic-admin"
require "webmock/rspec"

RSpec.configure do |config|
  # Add custom RSpec configuration here
end

# Description:
#   Method provide sample did_token for configure specs
#
# Returns:
#   did_token
#

def spec_did_token
  "WyIweHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDA"\
  "wMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMH"\
  "Rlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwMDAiLCJ7XCJpYXRcIjoxMjM0N"\
  "TEyMzQ1LFwiZXh0XCI6MTIzNDUxMjM0NSxcImlzc1wiOlwiZGlkOmV0aHI6MHh0ZXN0"\
  "MDAwMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwXCIsXCJzdWJcIjpcIjA"\
  "wYWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY3ODkwMDAwMDA9XCIsXCJhdW"\
  "RcIjpcImRpZDptYWdpYzp0ZXN0dGVzdC10ZXN0LXRlc3QtdGVzdC10ZXN0dGVzdHRlc"\
  "3RcIixcIm5iZlwiOjEyMzQ1MTIzNDUsXCJ0aWRcIjpcInRlc3R0ZXN0LXRlc3QtdGVz"\
  "dC10ZXN0LXRlc3R0ZXN0dGVzdFwiLFwiYWRkXCI6XCIweDAwdGVzdDAwMDB0ZXN0MDA"\
  "wMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMH"\
  "Rlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc3QwMDAwdGVzdDAwMDB0ZXN0MDAwMHRlc"\
  "3QwMDAwdGVzdDAwMDBcIn0iXQ=="
end

# Description:
#   Method provide sample api_secret_key for configure specs
#
# Returns:
#   api_secret_key
#

def spec_api_secret_key
  "sk_test_TESTTESTTESTTEST"
end

def spec_client_id
  "clientId12345="
end