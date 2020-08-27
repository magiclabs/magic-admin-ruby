# frozen_string_literal: true

# Magic Ruby bindings
require 'etc'
require "json"
require "net/http"
require "uri"

# Version
require "magic/version"

# Magic API Classes
require "magic/util"
require "magic/config"
require "magic/errors"

# HTTP Classes
require "magic/http/client"
require "magic/http/request"
require "magic/http/response"

# Magic API Client
require "magic/client"

# Magic Test Classes
require "test"

module Magic
end
