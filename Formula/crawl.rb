class Crawl < Formula
  desc "Dungeon Crawl Stone Soup: The CLI Version"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/releases/download/0.32.1/dcss-0.32.1.tar.xz"
  version "0.32.1"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" # Placeholder

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "lua@5.1"
  depends_on "sqlite"
  depends_on "ncurses"

  def install
    # Crawl has a complex build system. We force it to build the CLI version.
    # We specify the prefix so it installs into Homebrew's folder.
    
    cd "source" do
      system "make", "install", "prefix=#{prefix}", "DATADIR=#{pkgshare}", "TILES=n"
    end
    
    # Symlink the binary to 'crawl'
    bin.install_symlink "#{prefix}/bin/crawl"
  end

  test do
    # Run version check
    system "#{bin}/crawl", "--version"
  end
end
