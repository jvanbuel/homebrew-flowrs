class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.15/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "80c964f7bafbd247d7bb2eb925afe1ddd8b55a9f7a1045ab92a972843d5409c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.15/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "7be8b36a864b32af857396be3b571e1d4e73a1fcd37e5d79bf2dac1b1bd69372"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.15/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2a92849cbd72e3777fbe8af53a5988ef0a3e418e73a5c38038b7ae79f8257253"
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
