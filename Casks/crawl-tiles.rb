cask "crawl-tiles" do
  version "0.33.1"
  # This is the SHA for the Cask:
  sha256 "aa63f58d606afdd158bc6b0139c97b0e36a4062cb73641e637d03e2732c032b5"

  url "https://github.com/crawl/crawl/releases/download/#{version}/dcss-#{version}-macos-tiles-universal.zip"
  name "Dungeon Crawl Stone Soup"
  desc "Roguelike dungeon crawler with tiles graphics"
  homepage "https://crawl.develz.org/"

  app "Dungeon Crawl Stone Soup.app"

  zap trash: [
    "~/Library/Application Support/Dungeon Crawl Stone Soup",
    "~/Library/Saved Application State/net.sourceforge.crawl-ref.savedState",
  ]
end
