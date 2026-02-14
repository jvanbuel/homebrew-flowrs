class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.8.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.8.10/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "f98a512926bac38e0457ba24ed01614ccd0051ae5956c1f12f15520db73bc07b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.8.10/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "a23d1891e0e085c78ae52a1fdacb561d2f42d56bb2a04619f36a54d262908e6a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.8.10/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "da60f8ba041ecf3abda283e67c54cf37614c9416f4b9a8d9efcbb82ed8d0ccb7"
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
    bin.install "flowrs" if OS.mac? && Hardware::CPU.arm?
    bin.install "flowrs" if OS.mac? && Hardware::CPU.intel?
    bin.install "flowrs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
