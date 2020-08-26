# frozen_string_literal: true

# Magic Ruby bindings
require 'etc'
require "json"
require "net/http"
require "uri"

# Version
require "magic/version"

# API Support Classes
require "magic/support/errors"
require "magic/support/config"
require "magic/support/util"

# HTTP Classes
require "magic/http/client"
require "magic/http/request"
require "magic/http/response"

# API Client Class
require "magic/client"

module Magic
end
