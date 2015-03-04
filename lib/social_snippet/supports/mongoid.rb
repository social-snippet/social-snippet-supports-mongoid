require "mongoid"
require_relative "mongoid/version"
require_relative "mongoid/mongoid_document"

module SocialSnippet

  module Supports

    module Mongoid

      def self.activate!
        MongoidDocument.activate!
      end

    end

  end

end

