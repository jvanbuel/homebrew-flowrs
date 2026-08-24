class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.14.0/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "50c36d7e2f795b79b3c47f23633b9ab337eb441f00c57f4b4c21edb35f81e2c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.14.0/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "56f533604764f0090ddec914e10f6d71a3e650e8f4a904418e6d12445c483b79"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.14.0/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9a4f06a90e4139c42f42f8e787662bd9181e65261c9da3c67a53fe2aef39e7d9"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
      bin.install "flowrs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "flowrs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flowrs"
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
