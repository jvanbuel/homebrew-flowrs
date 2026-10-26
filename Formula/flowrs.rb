class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.16.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.16.2/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "0eac3c149a176b5bc025971b45ba2835fe25dea8eea7157e463d7e0c930e17aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.16.2/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "e1f83db37b8a331e9ac8d5daf7f5f440b5516714e9bec3911cac39b3aec6b466"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.16.2/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b6ef592d537f1eac699da5a8d783d75042620c3590f771c28b27f9323511ec67"
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
