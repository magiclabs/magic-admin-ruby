# frozen_string_literal: true

require "bundler/setup"
Bundler.setup

require "magic-admin"
require "webmock/rspec"

RSpec.configure do |config|
  #config.pattern = "**{,/*/**}/*_test.rb"
  # Add custom RSpec configuration here
end

# Description:
#   Method provide sample did_token for configure specs
#
# Returns:
#   did_token
#

def spec_did_token
  "WyIweDdmNjM0ZTg4NTNiNDBiOTZhMTNiM2EyNjc3MGI3ZThjNTgwNTFjZDkyNDVjZTl"\
  "hOGI4NjMwMzNiYzIwMDU1ODc1MTQ3M2UyZWI4YzVlYzhhYWNkZjQwMjgwNTJlNGE2MW"\
  "E2YWMyODUxOTY5OTZlYzJmZjZmODZhNzg4MWE3Zjk1MWMiLCJ7XCJpYXRcIjoxNTk5M"\
  "TQ5OTkxLFwiZXh0XCI6MTU5OTE1MDg5MSxcImlzc1wiOlwiZGlkOmV0aHI6MHg4NTgw"\
  "RGU1M2JBMzdCNDIwNUNkRDAyODZEMDMzNTkyZkNGZmNlMEE2XCIsXCJzdWJcIjpcInd"\
  "TRGlsdk1Jc3hadnFQNkV3SVh5ZGUtbjdnamxxNThURy1PbnVUY3pOcms9XCIsXCJhdW"\
  "RcIjpcImRpZDptYWdpYzo3OWYyMmVkYi1kYWNlLTQwMTktYWU3YS1lY2U2ZWQwYTAxY"\
  "TRcIixcIm5iZlwiOjE1OTkxNDk5OTEsXCJ0aWRcIjpcIjM1YTI3MTYxLTE0YTItNDJj"\
  "Ny05ZjliLWViYWE3NzA0OGNjZFwiLFwiYWRkXCI6XCIweGE1Zjc3YTA1YTFmNDBmMWQ"\
  "wN2JjOTA4MTg1ZWJkMzFlNTY4MWU4NTY4YzMyYjAzMzU2MTA1M2I5Y2U5ODJhMTYwMz"\
  "M3M2NkNTI4YzFkNWNkYWNlNTkwMzVjYjhmMmE4YjE1OWNjN2I1ZGJiZjgzMDkyMjA3M"\
  "zdiMzVlYmEzZWU5MWJcIn0iXQ=="
end

# Description:
#   Method provide sample api_secret_key for configure specs
#
# Returns:
#   api_secret_key
#

def spec_api_secret_key
  "sk_test_B244AAC8604E380A"
end
