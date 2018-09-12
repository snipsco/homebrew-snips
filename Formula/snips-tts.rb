class SnipsTts < Formula
  desc "Snips TTS"
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
    sha256 "024d0f8fda435b66aa540915d702001f690d5a7efadf1c8c8997139bfc472ed3" => :high_sierra_or_later
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build
  depends_on "snips-platform-common"

  def install
    target_dir = build.with?("debug") ? buildpath/"target/debug" : buildpath/"target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-tts/snips-tts"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-tts"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-tts.bash"
      fish_completion.install "#{target_dir}/completion/snips-tts.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-tts"
    end
  end

  plist_options :manual => "snips-tts -c #{HOMEBREW_PREFIX}/etc/snips.toml"

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
          <string>#{opt_bin}/snips-tts</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-tts.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-tts.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-tts #{version}\n", shell_output("#{bin}/snips-tts --version")
  end
end
