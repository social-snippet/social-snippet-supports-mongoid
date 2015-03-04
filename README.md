# SocialSnippet::Supports::Mongoid

[![Build Status](https://travis-ci.org/social-snippet/social-snippet-supports-mongoid.svg?branch=master)](https://travis-ci.org/social-snippet/social-snippet-supports-mongoid)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'social_snippet-supports-mongoid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install social_snippet-supports-mongoid

## Usage

```ruby
require "social_snippet"
require "social_snippet/supports/mongoid"
SocialSnippet::Supports::Mongoid.activate!
# Document  <= MongoidDocument
# Storage   <= MongoidStorage
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/social_snippet-supports-mongoid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

