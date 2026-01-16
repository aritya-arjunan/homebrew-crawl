#!/bin/bash

# ====================================================
# CONFIGURATION
# ====================================================
GH_USER="aritya-arjunan" 
REPO_NAME="homebrew-crawl"
TARGET_DIR="/usr/local/Homebrew/Library/Taps/$GH_USER/$REPO_NAME"

CRAWL_VERSION="0.33.1"

# CORRECT URLS (Based on your screenshot)
# Formula uses the source code tarball
FORMULA_URL="https://github.com/crawl/crawl/releases/download/${CRAWL_VERSION}/stone_soup-${CRAWL_VERSION}.tar.xz"

# Cask uses the pre-compiled macOS Tiles zip
CASK_URL="https://github.com/crawl/crawl/releases/download/${CRAWL_VERSION}/dcss-${CRAWL_VERSION}-macos-tiles-universal.zip"

echo "🏰 Updating Dungeon Crawl Stone Soup Repo to v$CRAWL_VERSION..."

# 1. SETUP FOLDERS
mkdir -p "$TARGET_DIR/Formula"
mkdir -p "$TARGET_DIR/Casks"
mkdir -p "$TARGET_DIR/.github/workflows"
cd "$TARGET_DIR"

# ====================================================
# 2. CREATE THE FORMULA (Command Line Version)
# ====================================================
echo "📜 Writing Formula (CLI)..."
cat <<EOF > Formula/crawl.rb
class Crawl < Formula
  desc "Dungeon Crawl Stone Soup: The CLI Version"
  homepage "https://crawl.develz.org/"
  url "$FORMULA_URL"
  version "$CRAWL_VERSION"
  sha256 "PLACEHOLDER_SHA" # Run brew fetch to get this!

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "lua@5.1"
  depends_on "sqlite"
  depends_on "ncurses"
  depends_on "pcre"

  def install
    # DCSS Build System
    # The source code is in the 'source' subdirectory
    cd "source" do
      # Build CLI version (TILES=n)
      system "make", "install", "prefix=#{prefix}", "DATADIR=#{pkgshare}", "TILES=n"
    end
    
    bin.install_symlink "#{prefix}/bin/crawl"
  end

  test do
    system "#{bin}/crawl", "--version"
  end
end
EOF

# ====================================================
# 3. CREATE THE CASK (Graphical/Tiles Version)
# ====================================================
echo "🎨 Writing Cask (GUI)..."
cat <<EOF > Casks/crawl-tiles.rb
cask "crawl-tiles" do
  version "$CRAWL_VERSION"
  sha256 "PLACEHOLDER_SHA" # Run brew fetch to get this!

  url "$CASK_URL"
  name "Dungeon Crawl Stone Soup"
  desc "Roguelike dungeon crawler with tiles graphics"
  homepage "https://crawl.develz.org/"

  # It is a zip file, so no DMG mounting needed. 
  # Homebrew unzips it and looks for the .app
  app "Dungeon Crawl Stone Soup.app"

  zap trash: [
    "~/Library/Application Support/Dungeon Crawl Stone Soup",
    "~/Library/Saved Application State/net.sourceforge.crawl-ref.savedState",
  ]
end
EOF

# ====================================================
# 4. CREATE THE WORKFLOW (Build Farm)
# ====================================================
echo "🤖 Updating Build Farm..."
cat <<EOF > .github/workflows/publish.yml
name: brew test-bot
on:
  push:
    branches:
      - main
  pull_request:

permissions:
  contents: read
  packages: write

jobs:
  test-bot:
    strategy:
      matrix:
        os: [macos-14, macos-15]
    runs-on: \${{ matrix.os }}
    steps:
      - name: Set up Homebrew
        id: set-up-homebrew
        uses: Homebrew/actions/setup-homebrew@master

      - name: Run brew test-bot --only-cleanup-before
        run: brew test-bot --only-cleanup-before

      - name: Run brew test-bot --only-setup
        run: brew test-bot --only-setup

      # Build CLI Bottle
      - name: Build Crawl Formula
        run: |
          brew test-bot --only-formulae --root-url=https://ghcr.io/v2/${GH_USER}/crawl crawl

      # Verify GUI Cask
      - name: Verify Crawl Cask
        run: |
          brew install --cask crawl-tiles

      - name: Upload bottles
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: bottles_\${{ matrix.os }}
          path: '*.bottle.*'
EOF

echo "========================================================"
echo "✅ UPDATED TO 0.33.1 (Fixed URLs)"
echo "========================================================"
echo "NOW DO THIS:"
echo "1. brew fetch --formula Formula/crawl.rb"
echo "   (Copy SHA -> Paste into Formula/crawl.rb)"
echo ""
echo "2. brew fetch --cask Casks/crawl-tiles.rb"
echo "   (Copy SHA -> Paste into Casks/crawl-tiles.rb)"
echo ""
echo "3. git add . && git commit -m 'Fix URLs' && git push"
echo "========================================================"
