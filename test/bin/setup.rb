require "mongoid"
ENV["RACK_ENV"] = "test"
require_relative "../../config/database"

require "social_snippet/supports/mongoid"
SocialSnippet::Supports::Mongoid.activate!
