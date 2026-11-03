class AgentDiscogs < Formula
  include Language::Python::Virtualenv

  desc "Token-efficient Discogs CLI for AI agents"
  homepage "https://github.com/jmfontaine/agent-discogs"
  url "https://files.pythonhosted.org/packages/bb/fe/a3ccde5fa56904489a677148de032291474beee5acb85a0a9dd17be36ace/agent_discogs-0.5.0.tar.gz"
  sha256 "28e21ecdccc619b52afc7829d0f1db9a7fdf478b6ce2b8fb4ca121d652d42094"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/jmfontaine/homebrew-tap/releases/download/agent-discogs-0.5.0"
    sha256 cellar: :any, arm64_tahoe: "c82de6f49ff97b48a68a54264d675b44d6aab438ed0c01597486a9db1fe03d08"
  end

  depends_on "rust" => :build # for pydantic-core
  depends_on "python@3.15"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "discogs-sdk" do
    url "https://files.pythonhosted.org/packages/b5/e4/77f11b67da5b5a2d45b577e15f87efe6d620d866d5e33ebe04f48b87add9/discogs_sdk-0.8.1.tar.gz"
    sha256 "c97f8fbdd844668ee7975f8268cb21ac6095d203cb88c31e04798644d70a207c"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/9f/d5/b4867fa7c7f04c34997d7d8aad744f64d210bb99d67cf18bf3fb1eea1aed/pydantic-2.14.2.tar.gz"
    sha256 "fb7b2db6cefe8414dd612edeede49c4c433acb0432b0f92b95024e45f66c505d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/8e/23ec1021834e35041fbb2f10946141e6acdfd39379c45cc4d65a4e8a1d98/pydantic_core-2.50.2.tar.gz"
    sha256 "1b0e8dc3932cf4e9ed5727570325cacc716b9409ffc794a221c0ccc72e8eb775"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/agent-discogs --version")

    skills = Pathname(shell_output("#{bin}/agent-discogs skills path").strip)
    assert_predicate skills, :directory?

    # `status` reports the auth mode and cache location without calling the API or opening the cache.
    status = shell_output("#{bin}/agent-discogs status")
    assert_match "agent-discogs v#{version}", status
    assert_match "Auth: none", status
  end
end
