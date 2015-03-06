require "mongoid"
require "pathname"
require "social_snippet/supports/mongoid/version"
require "social_snippet/document_backend/mongoid_document"
require "social_snippet/storage_backend/mongoid_storage"

module SocialSnippet::Supports

  module Mongoid

    def self.activate!
      ::SocialSnippet::DocumentBackend::MongoidDocument.activate!
      ::SocialSnippet::StorageBackend::MongoidStorage.activate!
    end

  end

end

