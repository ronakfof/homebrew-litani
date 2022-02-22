class Kani < Formula
  include Language::Python::Virtualenv
  desc "Kani Rust Verifier"
  homepage "https://model-checking.github.io/kani"
  url "https://github.com/ronakfof/kani/archive/refs/tags/1.1.3.tar.gz"
  sha256 "39db69fdd51362bf7b303125d9ea571089912749f22ec89e33e1694316b7fb20"
  license "NOASSERTION"

  depends_on "cbmc"
  depends_on "ronakfof/litani/cbmc-viewer"
  depends_on "rustup-init"

  resource "autopep8" do
      url "https://files.pythonhosted.org/packages/77/63/e88f70a614c21c617df0ee3c4752fe7fb66653cba851301d3bcaee4b00ea/autopep8-1.5.7.tar.gz"
      sha256 "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0"
  end

  resource "pycodestyle" do
      url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
      sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "toml" do
      url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
      sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3")
    venv.pip_install resources
    (libexec/"kani").install Dir["*"]
  end

  def post_install
    system "#{Formula["rustup"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    nightly_version = "nightly-2021-11-08"
    components = %w[rustc cargo]
    system "rustup", "toolchain", "install", nightly_version
    system "rustup", "component", "add", *components, "--toolchain", nightly_version
    cd libexec/"kani" do
      system "cargo", "build"
    end
  end

  def caveats
    <<~EOS
      Please add Kani scripts to PATH by running the following commands - 
      echo 'PATH="#{libexec}/kani/scripts:$PATH"' >> ~/.bash_profile
      export PATH="#{libexec}/kani/scripts:$PATH"
    EOS
  end

  test do
    (testpath/"test.rs").write <<~EOF
      // File: test.rs
      fn main() {
          assert!(1 == 1);
      }
    EOF
    system "which", "kani"
    system "kani", testpath/"test.rs"
  end
end
  