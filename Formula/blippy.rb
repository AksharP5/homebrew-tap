class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.7/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "906156ea5bfaca9a22af2eda0d13bb2d4e43f9e104bfa63b0e958057ec0b1d13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.7/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "6a2d0456b40388477321450ce5b02927b330577b0905170aa52a857a6d00d56a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AksharP5/blippy/releases/download/v0.1.7/blippy-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "877bdac5bccf4305eda3c2b31a898cfbc02b4c93ba7956a1e091e4775840d89f"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "blippy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "blippy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "blippy"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
