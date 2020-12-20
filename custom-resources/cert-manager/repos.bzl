load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def cert_manager_repositories():
    http_archive(
        name = "cert-manager",
        sha256 = "ae4b38bd7c1d88668e077fdca16b5505f75c9e2cd941db082a52290fba396901",
        strip_prefix = "cert-manager-1.1.0",
        # git diff --no-prefix --patch > custom-resources/cert-manager/upstream.patch
        patches = ["@manifesto//custom-resources/cert-manager:upstream.patch"],
        urls = ["https://github.com/jetstack/cert-manager/archive/v1.1.0.tar.gz"],
    )

    http_archive(
        name = "io_k8s_repo_infra",
        strip_prefix = "repo-infra-0.0.2",
        sha256 = "774e160ba1a2a66a736fdc39636dca799a09df015ac5e770a46ec43487ec5708",
        urls = ["https://github.com/kubernetes/repo-infra/archive/v0.0.2.tar.gz"],
    )
