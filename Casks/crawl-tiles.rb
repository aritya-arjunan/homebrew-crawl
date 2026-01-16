cask "crawl-tiles" do
  version "0.32.1"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" # Placeholder

  url "https://github.com/crawl/crawl/releases/download/#{version}/dcss-#{version}-macos-universal.dmg"
  name "Dungeon Crawl Stone Soup"
  desc "Roguelike dungeon crawler with tiles graphics"
  homepage "https://crawl.develz.org/"

  app "Dungeon Crawl Stone Soup.app"

  zap trash: [
    "~/Library/Application Support/Dungeon Crawl Stone Soup",
    "~/Library/Saved Application State/net.sourceforge.crawl-ref.savedState",
  ]
end
