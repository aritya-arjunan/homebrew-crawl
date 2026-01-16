class Crawl < Formula
  desc "Dungeon Crawl Stone Soup: The CLI Version"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/releases/download/0.33.1/stone_soup-0.33.1.tar.xz"
  version "0.33.1"
  # This is the SHA you just found:
  sha256 "4effc6c6a863236b5a451716f9e626c29bf8c9b060c536cc3b0ec4751468f0d4"

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "lua@5.1"
  depends_on "ncurses"
  depends_on "pcre"
  depends_on "sqlite"

  def install
    # DCSS Build System
    cd "source" do
      # Build CLI version (TILES=n)
      system "make", "install", "prefix=#{prefix}", "DATADIR=#{pkgshare}", "TILES=n"
    end

    # The Style Fix: Use the 'bin' helper
    bin.install_symlink bin/"crawl"
  end

  test do
    system bin/"crawl", "--version"
  end
end
