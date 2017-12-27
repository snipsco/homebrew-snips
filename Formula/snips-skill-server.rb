class SnipsSkillServer < Formula
  desc "Snips Skill Server"
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
