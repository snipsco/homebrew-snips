class SnipsPlatformCommon < Formula
  desc "Snips Platform Common"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.64.0", :revision => "6df6a46d5ccfb312163c60a0ce2b3b90d8136b54"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "f47b2fc62c1e514910c7f1d5034635f9afc599616a8bb3350b51c3d8028ef87c" => :el_capitan
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
