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
      realpath = resolve(path)
      paths.add normalize(path)
    end

    def write(path, content)
      realpath = resolve(path)
      raise ::Errno::EISDIR if directory?(path)
      paths.add realpath
      file = File.find_or_create_by(:path => realpath)
      file.update_attributes(
        :content => content,
      )
    end

    def read(path)
      realpath = resolve(path)
      raise ::Errno::EISDIR if directory?(path)
      file = File.find_by(
        :path => realpath,
      )
      file.content
    end

    def mkdir(path)
      realpath = resolve(path)
      raise ::Errno::EEXIST if exists?(realpath)
      paths.add dirpath(path)
    end

    def mkdir_p(path)
      realpath = resolve(path)
      raise ::Errno::EEXIST if file?(realpath)
      paths.add dirpath(path)
    end

    def exists?(path)
      realpath = resolve(path)
      paths.include?(realpath) ||
        paths.include?(dirpath realpath)
    end

    def rm(path)
      realpath = resolve(path)
      paths.delete realpath
    end

    def rm_r(path)
      realpath = resolve(path)
      paths.reject! do |tmp_path|
        tmp_path.start_with? realpath
      end
    end

    def directory?(path)
      realpath = resolve(path)
      paths.include? dirpath(realpath)
    end

    def file?(path)
      realpath = resolve(path)
      paths.include? realpath
    end

    def glob(pattern)
      realpattern = resolve(pattern)
      paths.select do |path|
        ::File.fnmatch realpattern, path, ::File::FNM_PATHNAME
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

    def resolve(path)
      if absolute?(path)
        normalize(path)
      else
        normalize(::File.join workdir, path)
      end
    end

    def dirpath(path)
      path + "/"
    end

    def normalize(path)
      ::Pathname.new(path).cleanpath.to_s
    end

  end

end

