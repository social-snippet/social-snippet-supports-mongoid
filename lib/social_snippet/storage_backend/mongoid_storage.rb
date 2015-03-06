module SocialSnippet::StorageBackend

  class MongoidStorage

    require_relative "mongoid_storage/file"
    require_relative "mongoid_storage/model"

    attr_reader :paths
    attr_reader :workdir

    def initialize
      @workdir = "/"
      @paths = ::SortedSet.new
    end

    def cd(path)
      if absolute?(path)
        @workdir = normalize(path)
      else
        @workdir = normalize(::File.join workdir, path)
      end
    end

    def touch(path)
      paths.add normalize(path)
    end

    def write(path, content)
      raise ::Errno::EISDIR if directory?(path)
      realpath = normalize(::File.join workdir, path)
      paths.add realpath
      file = File.find_or_create_by(:path => realpath)
      file.update_attributes(
        :content => content,
      )
    end

    def read(path)
      raise ::Errno::EISDIR if directory?(path)
      realpath = normalize(::File.join workdir, path)
      file = File.find_by(:path => realpath)
      file.content
    end

    def mkdir(path)
      raise ::Errno::EEXIST if exists?(normalize path)
      paths.add dirpath(path)
    end

    def mkdir_p(path)
      raise ::Errno::EEXIST if file?(normalize path)
      paths.add dirpath(path)
    end

    def exists?(path)
      paths.include?(normalize path) ||
        paths.include?(dirpath path)
    end

    def rm(path)
      paths.delete normalize(path)
    end

    def rm_r(path)
      path = normalize(path)
      paths.reject! do |tmp_path|
        tmp_path.start_with? path
      end
    end

    def directory?(path)
      paths.include? dirpath(path)
    end

    def file?(path)
      paths.include? normalize(path)
    end

    def glob(pattern)
      paths.select do |path|
        ::File.fnmatch pattern, path, ::File::FNM_PATHNAME
      end
    end

    def pwd
      workdir
    end

    def self.activate!
      ::SocialSnippet.class_eval do
        remove_const :Storage if defined?(::SocialSnippet::Storage)
        const_set :Storage, ::SocialSnippet::StorageBackend::MongoidStorage
      end
    end

    private

    def absolute?(path)
      ::Pathname.new(path).absolute?
    end

    def dirpath(path)
      normalize(path) + "/"
    end

    def normalize(path)
      ::Pathname.new(::File.join path).cleanpath.to_s
    end

  end

end

