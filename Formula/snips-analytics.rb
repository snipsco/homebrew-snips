class SnipsAnalytics < Formula
  desc "Snips Analytics"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.62.3", :revision => "e78327b67ab827499dc5c5cf6f0060b81a9a5229"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "299ef21d4ea2897eaa059649c9293b6eb8f6eaa6c1e8eac01a4ba5ac9951ced1" => :el_capitan
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build
  depends_on "snips-platform-common"

  def install
    target_dir = build.with?("debug") ? "target/debug" : "target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-analytics/snips-analytics"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-analytics"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-analytics.bash"
      fish_completion.install "#{target_dir}/completion/snips-analytics.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-analytics"
    end
  end

  plist_options :manual => "snips-analytics -c #{HOMEBREW_PREFIX}/etc/snips.toml"

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
          <string>#{opt_bin}/snips-analytics</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-analytics.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-analytics.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-analytics #{version}\n", shell_output("#{bin}/snips-analytics --version")
  end
end
