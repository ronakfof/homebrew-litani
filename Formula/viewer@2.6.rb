class Viewer < Formula
    include Language::Python::Virtualenv

    desc "Scans the output of CBMC and produces a browsable summary of the results."
    homepage ""
    url "https://github.com/awslabs/aws-viewer-for-cbmc/archive/refs/tags/viewer-2.6.tar.gz"
    sha256 "c8927e6113866de51b3c5298032b281f05479a3ad7a83853ef724dfe2ca239ad"
    license "Apache-2.0"

    depends_on "ctags"
    depends_on "python3"

    resource "voluptuous" do
        url "https://files.pythonhosted.org/packages/c0/2c/ccbeb25364e3e0c5e4522f13d66e2fc639bb4d4ecdf73be0959552cbecb4/voluptuous-0.12.2.tar.gz"
        sha256 "4db1ac5079db9249820d49c891cb4660a6f8cae350491210abce741fabf56513"
    end

    def install
        virtualenv_install_with_resources
    end

    test do
        system "echo", "test1"
    end
  end
  