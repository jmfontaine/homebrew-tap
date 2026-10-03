class Redumper < Formula
  desc "Low-level optical disc dumper for CD, DVD, HD DVD and Blu-ray"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/b756.tar.gz"
  sha256 "7405aaf319cd65331d3d171d26fce9c1605d3f3161c40296407be34a78d940a1"
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

  # b751 (superg/redumper#447) started rejecting READ CDDA (D8) transfers whose byte
  # count differs from the sub-code payload. JMicron USB-ATAPI bridges (0x152D:0x2338)
  # pad transfers into a larger host buffer, so PLEXTOR lead-in reads fail on macOS.
  # Request exactly the payload size. Drop this patch and the `+d8fix` build suffix
  # together once upstream ships a fix.
  patch :DATA

  def install
    # The unit tests pull googletest via FetchContent, which Homebrew blocks.
    inreplace "CMakeLists.txt", 'add_subdirectory("tests")', ""

    args = %W[
      -DCMAKE_CXX_COMPILER=#{formula_opt_bin("llvm@18")}/clang++
      -DREDUMPER_VERSION_BUILD=b#{version}+d8fix
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
    assert_match "redumper (build: b#{version}+d8fix)", shell_output("#{bin}/redumper --version")
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

__END__
diff --git a/scsi/cmd.ixx b/scsi/cmd.ixx
index c8c4c4f..50bfd66 100644
--- a/scsi/cmd.ixx
+++ b/scsi/cmd.ixx
@@ -287,8 +287,12 @@ export SPTD::Status cmd_read_cdda(SPTD &sptd, uint8_t *sectors, uint32_t block_s
     *(uint32_t *)cdb.transfer_blocks = endian_swap(transfer_length);
     cdb.sub_code = (uint8_t)sub_code;
 
-    auto [status, transferred_length] = sptd.sendCommand(&cdb, sizeof(cdb), sectors, block_size * transfer_length);
-    if(!status.status_code && transferred_length != READ_CDDA_SIZES[(uint8_t)sub_code] * transfer_length)
+    // request exactly the sub-code payload: some USB-ATAPI bridges (JMicron 0x152D:0x2338) append padding when the host buffer is larger
+    uint32_t expected_length = READ_CDDA_SIZES[(uint8_t)sub_code] * transfer_length;
+    uint32_t buffer_length = block_size * transfer_length;
+
+    auto [status, transferred_length] = sptd.sendCommand(&cdb, sizeof(cdb), sectors, buffer_length < expected_length ? buffer_length : expected_length);
+    if(!status.status_code && transferred_length != expected_length)
         status.status_code = SPTD::HOST_SHORT_TRANSFER;
 
     return status;
