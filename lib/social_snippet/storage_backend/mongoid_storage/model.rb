module SocialSnippet::StorageBackend

  class MongoidStorage::Model
  
    include ::Mongoid::Document

    field :paths, :type => Array

  end

end

