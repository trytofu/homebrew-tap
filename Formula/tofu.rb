class Tofu < Formula
  desc "A terminal-first webhook relay CLI for local development."
  homepage "https://trytofu.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.1/tofu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5fd8b14715acc0bc688832931fcc411ed966b5e071f67fd2adb5519181ffde0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.1/tofu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e5b89912a2ff32a6fe5826b61178f75b470bd7a9a44c41c29bc31f3590b56402"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.1/tofu-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c4b773500456ea89f644642c1c1f3b05ac1074739f5364967ee99317448078b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/trytofu/tofu-cli/releases/download/v0.1.1/tofu-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "316872d726b0b749a95ed601677eb11c36e90d174f33e9eec13afd5ec91a95c4"
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
