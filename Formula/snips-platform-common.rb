class SnipsPlatformCommon < Formula
  desc "Snips Platform Common"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.63.3", :revision => "ff18192278224396305114ac5621d78f1056dcc7"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "571427eb0b6f0777e934c2ea4b6a43766c02908642a8e0b546a449d1890926f1" => :el_capitan
  end

  skip_clean "var/snips"

  def install
    mkdir_p "homebrew/snips"

    # Prepare /usr/share/snips/
    cp_r "snips-template/snips-actions-templates/templates", "homebrew/snips/snips-actions-templates"
    system "scripts/download-demo-assistant.sh", "-d", "-f homebrew/snips/"

    # Prepare /usr/etc/snips.toml
    config_file = "snips-platform-debian/snips-platform-common/etc/snips.toml"
    # Fix up default conf file to match homebrew paths
    inreplace config_file do |s|
      s.gsub! "/usr/share/snips", share/"snips"
      s.gsub! "/var/lib/snips", var/"snips"
    end

    share.install "homebrew/snips"

    etc.install config_file
  end

  def post_install
    (var/"snips").mkpath
    (var/"log/snips").mkpath
  end

  def caveats; <<~EOS
    snips-platform-common has been installed with a default configuration file.
    You can make changes to the configuration by editing:
      #{etc}/snips.toml
  EOS
  end

  test do
    assert_predicate etc/"snips.toml", :exist?, "snips.toml is missing"
    assert_predicate share/"snips/assistant/", :exist?, "Demo assistant is missing"
    assert_predicate share/"snips/snips-actions-templates/", :exist?, "Template files are missing"
    assert_predicate var/"snips", :exist?, "snips working directory is missing"
  end
end
