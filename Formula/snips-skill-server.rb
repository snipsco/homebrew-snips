class SnipsSkillServer < Formula
  desc "Snips Skill Server"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.60.12", :revision => "ca0049c0acca3913da7b3b27e26b4f9d6ba71463"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "43e1b70217ee8dbecbddcb0b886bbaaeee54759e69f7f4bf29ea8958ecfa334a" => :el_capitan
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build

  def install
    target_dir = build.with?("debug") ? "target/debug" : "target/release"

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

  plist_options :manual => "snips-skill-server -c #{HOMEBREW_PREFIX}/etc/snips.toml"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/snips-skill-server</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-skill-server.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-skill-server.log</string>
        <key>ProcessType</key>
        <string>Interactive</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-skill-server #{version}\n", shell_output("#{bin}/snips-skill-server --version")
  end
end
