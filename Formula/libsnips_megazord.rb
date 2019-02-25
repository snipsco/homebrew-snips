class LibsnipsMegazord < Formula
  desc "C interface for Snips's platform library"
  homepage "https://snips.ai"

  url "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :tag => "0.61.1", :revision => "074184f556b4058c8fb4f0c0aba681a9e54c35bd"

  head "ssh://git@github.com/snipsco/snips-platform.git",
    :using => :git, :branch => "develop"

  bottle do
    root_url "https://homebrew.snips.ai/bottles"
    cellar :any
    sha256 "a9f9ca5283715ac58258b6e5f8863014a90b5da8720e4160706de203f06461e2" => :el_capitan
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
      Libs: -L#{lib} -lsnips_megazord -fAccelerate
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
