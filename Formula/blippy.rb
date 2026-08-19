class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.11/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "c90f4994861abe24045918f34aca7e1c3711471a612066d44e761efed6b516e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.11/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "a302c7fa2386c23a81098c6eaa57eb19c0e9fc38d1f7c7baf02a138413bf24ac"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AksharP5/blippy/releases/download/v0.1.11/blippy-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f8e038e2f2822a9befb7ef607ed3c5c7ac0150c1229065babcf10696375ec045"
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
