require "mongoid"
require "social_snippet/supports/mongoid/version"
require "social_snippet/document_backend/mongoid_document"

module SocialSnippet::Supports

  module Mongoid

    def self.activate!
      ::SocialSnippet::DocumentBackend::MongoidDocument.activate!
    end

  end

end

