class SnipsSkillServer < Formula
  desc "Snips Skill Server"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.60.1",
    :revision => "c943f9f110c9748738121a586dbd004f9aa1b585"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    sha256 "16394d86ed35bac60026d82f02a23e21bf05ab0062fa4d42075f21de274c49e6" => :el_capitan_or_later
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build

  def install
    target_dir = build.with?("debug") ? buildpath/"target/debug" : buildpath/"target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-skill-server/snips-skill-server"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-skill-server"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-skill-server.bash"
      fish_completion.install "#{target_dir}/completion/snips-skill-server.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-skill-server"
    end
  end

  test do
    assert_equal "snips-skill-server #{version}\n", shell_output("#{bin}/snips-skill-server --version")
  end
end
