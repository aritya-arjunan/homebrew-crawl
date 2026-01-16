class Crawl < Formula
  desc "Dungeon Crawl Stone Soup: The CLI Version"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/releases/download/0.33.1/stone_soup-0.33.1.tar.xz"
  sha256 "4effc6c6a863236b5a451716f9e626c29bf8c9b060c536cc3b0ec4751468f0d4"

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "pcre"
  depends_on "sqlite"
  depends_on "ncurses"

  def install
    cd "source" do
      # BUILD_LUA=y builds the internal copy of Lua bundled with the game source.
      # This resolves the "Can't find dependency lua@5.1" error.
      system "make", "install", "prefix=#{prefix}",
                                "DATADIR=#{pkgshare}",
                                "TILES=n",
                                "BUILD_LUA=y"
    end

    bin.install_symlink bin/"crawl"
  end

  test do
    system bin/"crawl", "--version"
  end
end
