class Flowrs < Formula
  desc "Flowrs is a Terminal User Interface (TUI) for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  version "0.12.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.12.4/flowrs-tui-aarch64-apple-darwin.tar.xz"
      sha256 "9b0d33a4e71eeef9a243ab1f06b431e6383284c74fe2f87fef561b5c3dd373af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.12.4/flowrs-tui-x86_64-apple-darwin.tar.xz"
      sha256 "b3b753b10911fe7591175c8a279d8a2fa97bb4c93eccaa9aba6c8408d524ac1c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jvanbuel/flowrs/releases/download/flowrs-tui-v0.12.4/flowrs-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "155edfeafd65be723234c1f4455cb14b5c405b1d785d9375ae95ed7cbfdf76be"
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
