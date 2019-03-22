class SnipsAsrGoogle < Formula
  desc "Snips ASR Google"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.62.3", :revision => "e78327b67ab827499dc5c5cf6f0060b81a9a5229"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "707421260462c9f7344b7d7f433348ca6110c5a4c95bab4da3ca5f0d7093e6be" => :el_capitan
  end

  option "with-debug", "Build with debug support"

  depends_on "protobuf@3.1" => :build
  depends_on "rust" => :build
  depends_on "snips-platform-common"

  def install
    target_dir = build.with?("debug") ? "target/debug" : "target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-asr-google/snips-asr-google"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-asr-google"
  end

  plist_options :manual => "snips-asr-google -c #{HOMEBREW_PREFIX}/etc/snips.toml"

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
          <string>#{opt_bin}/snips-asr-google</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-asr-google.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-asr-google.log</string>
        <key>ProcessType</key>
        <string>Interactive</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-asr-google #{version}\n", shell_output("#{bin}/snips-asr-google --version")
  end
end
