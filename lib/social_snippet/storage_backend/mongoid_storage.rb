module SocialSnippet::StorageBackend

  class MongoidStorage

    include ::Mongoid::Document

    attr_reader :tmp_paths
    attr_reader :workdir

    def initialize
      @workdir = "/"
      @tmp_paths = ::SortedSet.new
    end

    def cd(path)
      @workdir = normalize(::File.join workdir, path)
    end

    def touch(path)
      tmp_paths.add normalize(path)
    end

    def write(path, content)
      tmp_paths.add normalize(path)
    end

    def read(path)
    end

    def mkdir(path)
      tmp_paths.add dirpath(path)
    end

    def mkdir_p(path)
      tmp_paths.add dirpath(path)
    end

    def exists?(path)
      tmp_paths.include?(normalize path) ||
        tmp_paths.include?(dirpath path)
    end

    def rm(path)
      tmp_paths.delete normalize(path)
    end

    def rm_r(path)
      tmp_paths.reject! do |tmp_path|
        tmp_path.start_with? path
      end
    end

    def directory?(path)
      tmp_paths.include? dirpath(path)
    end

    def file?(path)
      tmp_paths.include? normalize(path)
    end

    def glob(pattern)
      tmp_paths.select do |path|
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

    def dirpath(path)
      normalize(path) + "/"
    end

    def normalize(path)
      ::Pathname.new(path).cleanpath.to_s
    end

  end

end

