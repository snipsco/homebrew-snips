class SnipsHotword < Formula
  desc "Snips Hotword"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.60.2",
    :revision => "bcf326aebf1ab60e9acd8ca2c0843b628d4c887a"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    sha256 "8d52402c0e7a86dd13ae0a39b0451a6bdccdee0701cc908f6e2c77f614794cb6" => :el_capitan_or_later
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "portaudio"
  depends_on "snips-platform-common"

  def install
    target_dir = build.with?("debug") ? buildpath/"target/debug" : buildpath/"target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-hotword/snips-hotword"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-hotword"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-hotword.bash"
      fish_completion.install "#{target_dir}/completion/snips-hotword.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-hotword"
    end
  end

  plist_options :manual => "snips-hotword -c #{HOMEBREW_PREFIX}/etc/snips.toml"

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
          <string>#{opt_bin}/snips-hotword</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-hotword.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-hotword.log</string>
        <key>ProcessType</key>
        <string>Interactive</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-hotword #{version}\n", shell_output("#{bin}/snips-hotword --version")
  end
end
