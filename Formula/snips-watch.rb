class SnipsWatch < Formula
  desc "Snips Watch"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.59.0-RC0",
    :revision => "b348ed6d8be7ca50aef7a11c6889cb6eae8ef9c7"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    sha256 "1bb689eebe0c5cb27ea2625b75cf3b407513e46747f09197cdc132ec58199de3" => :high_sierra_or_later
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build

  def install
    target_dir = build.with?("debug") ? buildpath/"target/debug" : buildpath/"target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-watch/snips-watch"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-watch"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-watch.bash"
      fish_completion.install "#{target_dir}/completion/snips-watch.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-watch"
    end
  end

  test do
    assert_equal "snips-watch #{version}\n", shell_output("#{bin}/snips-watch --version")
  end
end
