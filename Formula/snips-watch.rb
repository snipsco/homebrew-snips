class SnipsWatch < Formula
  desc "Snips Watch"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.60.3", :revision => "36f15ae289ec203aea2437d986a93b83e8710cf1"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    sha256 "f0c1e35c95f24c1610931f3cdc9102c59581951c9551e0a6b4ebb3b27a6be156" => :el_capitan
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
