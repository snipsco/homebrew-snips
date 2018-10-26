class SnipsDialogue < Formula
  desc "Snips Dialogue"
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
    sha256 "f34b872cd51213f021a75b9a3719d48ac36ea645b148998a09109a9946b4b487" => :el_capitan_or_later
  end

  option "with-debug", "Build with debug support"
  option "without-completion", "bash, zsh and fish completion will not be installed"

  depends_on "rust" => :build
  depends_on "snips-platform-common"

  def install
    target_dir = build.with?("debug") ? buildpath/"target/debug" : buildpath/"target/release"

    args = %W[--root=#{prefix}]
    args << "--path=snips-dialogue/snips-dialogue"
    args << "--debug" if build.with? "debug"

    system "cargo", "install", *args

    bin.install "#{target_dir}/snips-dialogue"

    if build.with? "completion"
      bash_completion.install "#{target_dir}/completion/snips-dialogue.bash"
      fish_completion.install "#{target_dir}/completion/snips-dialogue.fish"
      zsh_completion.install "#{target_dir}/completion/_snips-dialogue"
    end
  end

  plist_options :manual => "snips-dialogue -c #{HOMEBREW_PREFIX}/etc/snips.toml"

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
          <string>#{opt_bin}/snips-dialogue</string>
          <string>-c</string>
          <string>#{etc}/snips.toml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/snips/snips-dialogue.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/snips/snips-dialogue.log</string>
        <key>ProcessType</key>
        <string>Interactive</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "snips-dialogue #{version}\n", shell_output("#{bin}/snips-dialogue --version")
  end
end
