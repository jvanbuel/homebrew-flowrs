class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.4.2/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "0b4f1f19511806a922376f4d70461e5affead3f242b68a0cad738d4f1841fa0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.4.2/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "3a486a6c755e4faecd730218c17fd7f904f4c3bac87b3c39efb99364a4d937e0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/v0.4.2/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "084c35de12202dfd923ad9ccb3f48e1c178cd24635182bd2cd6943c6acea49ca"
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
