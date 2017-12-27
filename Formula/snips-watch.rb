class SnipsWatch < Formula
  desc "Snips Watch"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.59.0-DONT-USE",
    :revision => "3dc6d221232a439115e2edcda43f46f27fdd5170"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

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
