require "bundler/setup"

# prepare mongoid
require "mongoid"
ENV["RACK_ENV"] = "test"
require_relative "../config/database"

# prepare document
require "social_snippet/rspec/test_document"
require_relative "../lib/social_snippet/supports/mongoid"
SocialSnippet::Supports::Mongoid.activate!

# prepare helpers
require_relative "helpers/database_cleaner"

