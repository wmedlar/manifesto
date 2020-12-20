load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@manifesto//custom-resources:repos.bzl", "custom_resources_repositories")
load("@manifesto//lib:repos.bzl", "lib_repositories")

def manifesto_repositories():
    # bazel_skylib repositories
    http_archive(
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    )

    # rules_jsonnet repositories
    http_archive(
        name = "io_bazel_rules_jsonnet",
        sha256 = "7f51f859035cd98bcf4f70dedaeaca47fe9fbae6b199882c516d67df416505da",
        strip_prefix = "rules_jsonnet-0.3.0",
        urls = ["https://github.com/bazelbuild/rules_jsonnet/archive/0.3.0.tar.gz"],
    )
    # the following are copied from:
    # https://github.com/bazelbuild/rules_jsonnet/blob/0.3.0/jsonnet/jsonnet.bzl
    http_archive(
        name = "jsonnet",
        sha256 = "0b58f2a36a5625c717e717a7e85608730e7bb5bfd8be1765dd6fa23be1f9b9e8",
        strip_prefix = "jsonnet-0.15.0",
        urls = [
            "https://github.com/google/jsonnet/archive/v0.15.0.tar.gz",
        ],
    )
    git_repository(
        name = "jsonnet_go",
        remote = "https://github.com/google/go-jsonnet",
        commit = "70a6b3d419d9ee16a144345c35e0305052c6f2d9",  # v0.15.0
        shallow_since = "1581289066 +0100",
        init_submodules = True,
    )

    # rules_k8s repositories
    http_archive(
        name = "io_bazel_rules_k8s",
        strip_prefix = "rules_k8s-0.6",
        urls = ["https://github.com/bazelbuild/rules_k8s/archive/v0.6.tar.gz"],
        sha256 = "51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef",
    )
    # the following are copied from:
    # https://github.com/bazelbuild/rules_k8s/blob/v0.6/k8s/k8s.bzl
    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "08c3cd71857d58af3cda759112437d9e63339ac9c6e0042add43f4d94caf632d",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.2/rules_go-v0.24.2.tar.gz",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.24.2/rules_go-v0.24.2.tar.gz",
        ],
    )
    http_archive(
        name = "bazel_gazelle",
        sha256 = "d4113967ab451dd4d2d767c3ca5f927fec4b30f3b2c6f8135a2033b9c05a5687",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.0/bazel-gazelle-v0.22.0.tar.gz",
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.0/bazel-gazelle-v0.22.0.tar.gz",
        ],
    )
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "6287241e033d247e9da5ff705dd6ef526bac39ae82f3d17de1b69f8cb313f9cd",
        strip_prefix = "rules_docker-0.14.3",
        urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.3/rules_docker-v0.14.3.tar.gz"],
    )

    # subpackage repositories
    custom_resources_repositories()
    lib_repositories()
