module SocialSnippet::StorageBackend

  class MongoidStorage

    require_relative "mongoid_storage/file"
    require_relative "mongoid_storage/model"

    attr_reader :paths
    attr_reader :workdir
    attr_reader :model

    def initialize
      @workdir = "/"
      @model = Model.find_or_create_by(:id => "social_snippet_storage")
      @paths = ::SortedSet.new model.paths
    end

    def cd(path)
      raise ::Errno::ENOENT unless exists?(path)
      if absolute?(path)
        @workdir = normalize(path)
      else
        @workdir = resolve(path)
      end
    end

    def touch(path)
      raise ::Errno::ENOENT unless exists?(::File.dirname path)
      realpath = resolve(path)
      add_path realpath
    end

    def write(path, content)
      realpath = resolve(path)
      raise ::Errno::EISDIR if directory?(path)
      add_path realpath
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
      mkdir_p path
    end

    def mkdir_p(path)
      realpath = resolve(path)
      raise ::Errno::EEXIST if file?(realpath)
      add_dir realpath
    end

    def exists?(path)
      realpath = resolve(path)
      paths.include?(realpath) ||
        paths.include?(dirpath realpath)
    end

    def rm(path)
      raise ::Errno::ENOENT unless exists?(path)
      realpath = resolve(path)
      delete_path realpath
    end

    def rm_r(path)
      raise ::Errno::ENOENT unless exists?(path)
      realpath = resolve(path)
      paths.each do |tmp_path|
        delete_path tmp_path if tmp_path.start_with?(realpath)
      end
    end

    def directory?(path)
      realpath = resolve(path)
      paths.include? dirpath(realpath)
    end

    def file?(path)
      return false if directory?(path)
      realpath = resolve(path)
      paths.include? realpath
    end

    def glob(pattern)
      real_pattern = resolve(pattern)
      pattern_dir = dirpath(::File.dirname real_pattern)
      paths.select do |path|
        next if directory?(path) && path.end_with?("/")
        next if pattern_dir === path
        ::File.fnmatch real_pattern, path, ::File::FNM_PATHNAME
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

    def add_dir(path)
      add_path path
      add_path dirpath(path)
    end

    def add_parent_dir(path)
      items = path.split(::File::SEPARATOR)
      items.pop
      items.inject(::Array.new) do |tmp, item|
        tmp.push item
        add_dir ::File.join(*items)
        tmp
      end
    end

    def add_path(path)
      add_parent_dir path
      unless paths.include?(path)
        paths.add path
        model.push :paths => path
      end
    end

    def delete_path(path)
      paths.delete path
      model.pull :paths => path
    end

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

