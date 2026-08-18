class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.9/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "2e8d5ad809853767ef3ac05cf293c00895ea3a50d7416a6907cb2ee345875d86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.9/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "c2b4a12a390d90abbb4c5e1dc688da476ba186f180c893087efde5c0e5724938"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AksharP5/blippy/releases/download/v0.1.9/blippy-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4d71a44f9f0248b3df21ef379b8aaebe1823669a1c152473683a2775ee4a91a8"
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
