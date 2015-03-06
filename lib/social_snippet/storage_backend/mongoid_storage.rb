module SocialSnippet::StorageBackend

  class MongoidStorage

    def self.activate!
      ::SocialSnippet.class_eval do
        remove_const :Storage if defined?(::SocialSnippet::Storage)
        const_set :Storage, ::SocialSnippet::StorageBackend::MongoidStorage
      end
    end

  end

end

