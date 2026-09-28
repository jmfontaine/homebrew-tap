class Redumper < Formula
  desc "Low-level optical disc dumper for CD, DVD, HD DVD and Blu-ray"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/b753.tar.gz"
  sha256 "5ad24998bbd31ec4f78b570884dffc5d5dbd4e8c3d2daa4915492b9a3ad0508f"
  license "GPL-3.0-only"

  # Upstream tags every CI build as `bNNN`; Homebrew parses the version as `NNN`.
  livecheck do
    url :stable
    regex(/^b(\d+)$/i)
    strategy :github_latest
  end

  # Upstream builds with LLVM 18: C++20 modules need clang-scan-deps, which Xcode
  # does not ship, and newer libc++ releases drop transitive includes it relies on.
  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on "ninja" => :build
  depends_on :macos

  def install
    # The unit tests pull googletest via FetchContent, which Homebrew blocks.
    inreplace "CMakeLists.txt", 'add_subdirectory("tests")', ""

    args = %W[
      -DCMAKE_CXX_COMPILER=#{formula_opt_bin("llvm@18")}/clang++
      -DREDUMPER_VERSION_BUILD=b#{version}
      -DCLANG_TIDY=OFF
    ]
    # Recent macOS SDK headers declare CF_ENUM typedefs that clang 18 rejects.
    args << "-DCMAKE_CXX_FLAGS=-Wno-elaborated-enum-base"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    # Upstream's install rules bundle LLVM's libc++ for its release archives;
    # the formula links against the system libc++ instead.
    system "cmake", "--build", "build", "--target", "redumper"
    bin.install "build/redumper"
  end

  test do
    assert_match "redumper (build: b#{version})", shell_output("#{bin}/redumper --version")
    assert_match "PLEXTOR", shell_output("#{bin}/redumper --list-recommended-drives")

    (testpath/"src").mkpath
    (testpath/"src/hello.txt").write "hello\n"
    system "hdiutil", "makehybrid", "-quiet", "-iso", "-default-volume-name", "BREWTEST",
           "-o", testpath/"test.iso", testpath/"src"

    sha1 = Digest::SHA1.file(testpath/"test.iso").hexdigest
    assert_match "sha1=\"#{sha1}\"", shell_output("#{bin}/redumper hash --image-path=#{testpath} --image-name=test")
    assert_match "volume identifier: BREWTEST",
                 shell_output("#{bin}/redumper info --image-path=#{testpath} --image-name=test")
  end
end
