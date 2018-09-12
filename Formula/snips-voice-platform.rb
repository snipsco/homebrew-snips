class SnipsVoicePlatform < Formula
  desc "Snips NLU"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.59.0-RC0",
    :revision => "b348ed6d8be7ca50aef7a11c6889cb6eae8ef9c7"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

  option "without-analytics", "Won't install snips-analytics"

  depends_on "snips-asr"
  depends_on "snips-asr-google"
  depends_on "snips-audio-server"
  depends_on "snips-dialogue"
  depends_on "snips-hotword"
  depends_on "snips-nlu"
  depends_on "snips-tts"
  depends_on "snips-watch"
  depends_on "snips-analytics" if build.with? "analytics"

  depends_on "mosquitto" => :recommended

  test do
    assert_equal "snips-asr #{version}\n", shell_output("#{bin}/snips-asr --version")
    assert_equal "snips-asr-google #{version}\n", shell_output("#{bin}/snips-asr-google --version")
    assert_equal "snips-audio-server #{version}\n", shell_output("#{bin}/snips-audio-server --version")
    assert_equal "snips-dialogue #{version}\n", shell_output("#{bin}/snips-dialogue --version")
    assert_equal "snips-hotword #{version}\n", shell_output("#{bin}/snips-hotword --version")
    assert_equal "snips-nlu #{version}\n", shell_output("#{bin}/snips-nlu --version")
    assert_equal "snips-tts #{version}\n", shell_output("#{bin}/snips-tts --version")
    assert_equal "snips-watch #{version}\n", shell_output("#{bin}/snips-watch --version")
    if build?.with("snips-analytics")
      assert_equal "snips-analytics #{version}\n", shell_output("#{bin}/snips-analytics --version")
    end
  end
end
