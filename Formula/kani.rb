class Kani < Formula
  include Language::Python::Virtualenv
  desc "Kani Rust Verifier"
  homepage "https://model-checking.github.io/kani"
  url "https://github.com/ronakfof/kani/archive/refs/tags/1.1.2.tar.gz"
  sha256 "6b1dcd7b89ed40405b212f35b58efa8b088cb9e3b1f671fac993a18b792dc312"
  license "NOASSERTION"

  depends_on "cbmc"
  depends_on "ronakfof/litani/viewer@2.6"
  depends_on "rustup-init"
  depends_on "python@3.7"
  
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
      url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
      sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3")
    venv.pip_install resources
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--default-toolchain", "nightly"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    libexec.mkpath
    cd libexec do
      system "git", "clone", "https://github.com/model-checking/kani.git"
      cd "kani" do
        system "git", "submodule", "update", "--init", "--depth", "1"
        system "cargo", "build"
        system "./scripts/kani-regression.sh"
      end
    end
    bin.install_symlink Dir["#{libexec}/kani/scripts/*"]
  end

  test do
    (testpath/"test.rs").write <<~EOF
      // File: test.rs
      fn main() {
          assert!(1 == 3);
      }
    EOF
    system "which", "kani"
    system "kani", testpath/"test.rs"
  end
end
  