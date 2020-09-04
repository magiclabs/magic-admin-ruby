# magic-admin-ruby


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'magic-admin'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install magic-admin
```

### Prerequisites

- Ruby 2.3+

## Quick Start
Before you start, you will need an API secret key. You can get one from the [Magic Dashboard](https://dashboard.magic.link/). Once you have the API secret key, you can instantiate a Magic object.

```ruby
require 'magic-admin'

magic = Magic.new(api_secret_key: '<YOUR_API_SECRET_KEY>')

magic.token.validate('DID_TOKEN')

# Read the docs to learn more! 🚀
```

Optionally if you would like, you can load the API secret key from the environment variable, `MAGIC_API_SECRET_KEY`.

```ruby
# Set the env variable `MAGIC_API_SECRET_KEY`.

magic = Magic.new
```

**Note**: The argument passed to the `Magic::Client` object takes precedence over the environment variable.

### Configure Network Strategy
The `Magic` object also takes in `retries`, `timeout` and `backoff` as optional arguments at the object instantiation time so you can override those values for your application setup.

```ruby
magic = Magic.new(retries: 5, timeout: 10, backoff: 0.03)

```

## Changelog
See [Changelog](CHANGELOG.md)

## License
See [License](LICENSE.txt)
