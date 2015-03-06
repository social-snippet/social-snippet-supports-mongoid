module ::SocialSnippet::StorageBackend

  class MongoidStorage::File

    include ::Mongoid::Document

    field :path, :type => String
    field :content, :type => String
    
  end

end

