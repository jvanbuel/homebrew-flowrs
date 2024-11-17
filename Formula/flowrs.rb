class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.3/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "e5f7bacbdc1cba1df2956a5b57fc934c3f7d46e54b1b5f279346b103910e4d29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.3/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "7e5d05bb8149922fee10c26cea4d2acbe92c2ed97d3e1ce79907122e0472b4d2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/v0.1.3/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7cb4b41f22059713c0c64c3d0b7ea5e99024915f2d808a81db3955f6109eda7f"
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
