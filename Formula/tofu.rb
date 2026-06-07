class Tofu < Formula
  desc "A terminal-first webhook relay CLI for local development."
  homepage "https://trytofu.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.0/tofu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6dcd0058e2863c81c7b2e2fdcc12ecc30147dfe4e9f654b61e625e2aa2bd80b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.0/tofu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "371224c274be8ebd29ff512e89b3fad32ce0784647298bdcb89367148821a6eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.0/tofu-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a2af67e531571b762dbcac51bafaac97dff287798d50b244dd4b973d25bd8af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.0/tofu-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ad4f53b894339fb49303550cdade4d5d48ef134bec212c4d242c3a6edef9c7a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "tofu" if OS.mac? && Hardware::CPU.arm?
    bin.install "tofu" if OS.mac? && Hardware::CPU.intel?
    bin.install "tofu" if OS.linux? && Hardware::CPU.arm?
    bin.install "tofu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
