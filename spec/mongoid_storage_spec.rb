require "spec_helper" 

describe ::SocialSnippet::StorageBackend::MongoidStorage do

  include_context :TestStorage

  context "create storage" do

    before do
      storage = ::SocialSnippet::StorageBackend::MongoidStorage.new
      storage.mkdir_p "path/to/dir"
      storage.cd "path/to"
      storage.touch "file"
      storage.write "file", "this is path/to/file"
    end

    context "re-create storage" do

      let(:storage) do
        ::SocialSnippet::StorageBackend::MongoidStorage.new
      end

      context "read path/to/file" do
        subject { storage.read "path/to/file" }
        it { should eq "this is path/to/file" }
      end

      context "glob path" do
        subject { storage.glob "path" }
        it { expect(subject.length).to eq 1 }
        it { should include ::File.join(storage.pwd, "path") }
      end

      context "glob path/t*" do
        subject { storage.glob "path/t*" }
        it { expect(subject.length).to eq 1 }
        it { should include ::File.join(storage.pwd, "path", "to") }
      end

      context "glob path/to/*" do
        subject { storage.glob "path/to/*" }
        it { expect(subject.length).to eq 2 }
        it { should include ::File.join(storage.pwd, "path", "to", "file") }
        it { should include ::File.join(storage.pwd, "path", "to", "dir") }
      end

    end # find storage

  end # create storage

end

