class SnipsWatch < Formula
  desc "Snips Watch"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.60.10", :revision => "52306741000f9e4d060345c551bcfd72214eadef"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "8a34c74910b4269d761374206bfe3bb0b74df1690816f5e731f5e23e1376f1d4" => :el_capitan
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
