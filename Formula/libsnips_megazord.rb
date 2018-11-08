class LibsnipsMegazord < Formula
  desc "C interface for Snips's platform library"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.60.3", :revision => "36f15ae289ec203aea2437d986a93b83e8710cf1"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any_skip_relocation
    sha256 "db0966e4b56917f4d61689c69d179701f7dd3a81fc1074ccff177123c65d1390" => :el_capitan
  end

  option "with-debug", "Build with debug support"

  depends_on "autoconf" => :build # needed by snips-fst-rs
  depends_on "automake" => :build # needed by snips-fst-rs
  depends_on "pkg-config" => :build # needed by snips-kaldi
  depends_on "rust" => :build
  depends_on "portaudio"

  def install
    target_dir = build.with?("debug") ? "target/debug" : "target/release"

    # Needed to build openfst (cstdint issue)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.11"
    args = %W[--package=snips-megazord]
    args << "--release" if build.without? "debug"
    system "cargo", "build", *args

    lib.install Dir.glob("#{target_dir}/libsnips_megazord.{a,dylib}")
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
