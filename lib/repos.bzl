load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def lib_repositories():
    git_repository(
        name = "jsonnetunit",
        remote = "https://github.com/yugui/jsonnetunit.git",
        tag = "v0.2.0",
    )
