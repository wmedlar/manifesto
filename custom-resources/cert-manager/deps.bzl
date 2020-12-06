load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def cert_manager_dependencies():
    http_archive(
        name = "cert-manager",
        sha256 = "ae4b38bd7c1d88668e077fdca16b5505f75c9e2cd941db082a52290fba396901",
        strip_prefix = "cert-manager-1.1.0",
        # git diff --no-prefix --patch > custom-resources/cert-manager/upstream.patch
        patches = ["@manifesto//custom-resources/cert-manager:upstream.patch"],
        urls = ["https://github.com/jetstack/cert-manager/archive/v1.1.0.tar.gz"],
    )
