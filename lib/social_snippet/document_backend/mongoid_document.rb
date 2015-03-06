module SocialSnippet::DocumentBackend

  class MongoidDocument

    include ::Mongoid::Document

    def self.activate!
      ::SocialSnippet.class_eval do
        remove_const :Document if defined?(::SocialSnippet::Document)
        const_set :Document, MongoidDocument
      end
    end

  end

end

