class LibsnipsMegazord < Formula
  desc "C interface for Snips's platform library"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :tag => "0.60.2",
    :revision => "bcf326aebf1ab60e9acd8ca2c0843b628d4c887a"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git,
    :branch => "develop"

  option "with-debug", "Build with debug support"

  depends_on "autoconf" => :build # needed by snips-fst-rs
  depends_on "automake" => :build # needed by snips-fst-rs
  depends_on "pkg-config" => :build # needed by snips-kaldi
  depends_on "rust" => :build
  depends_on "portaudio"

  def install
    target_dir = build.with?("debug") ? "target/debug" : "target/release"

    system "cargo", "build", "--package=snips-megazord", "--release" if build.without? "debug"

    lib.install target_dir/"libsnips_megazord.a"
    include.install "snips-megazord/platforms/c/libsnips_megazord.h"
    (lib/"pkgconfig/snips_megazord.pc").write <<~EOS
      Name: snips_megazord
      Description: Snips platform library
      Version: #{version}
      Libs: -L#{lib} -lsnips_megazord
      Cflags: -I#{include}
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsnips_megazord.h>
      int main() {
        printf("%s", SNIPS_VERSION);
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsnips_megazord", "-o", "test_snips", "test.c"
    assert_equal version, shell_output("./test_snips")
  end
end
