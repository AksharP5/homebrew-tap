class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.10/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "0850fcb9d3388fa6361701fde4cc1bfa9bfd428dc5c2c93849f5065e649ad8a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.10/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "937c2e4f88fd233224f8962b28d81cf6231f6b808fb02b320d28a32954bf6f4a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AksharP5/blippy/releases/download/v0.1.10/blippy-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "426a4483e9fe319136759337c7d618ad03c4439ab2b64180056855a4a9d595b2"
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
