load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file", "http_archive")

def manifesto_tools():
    http_file(
        name = "buildifier.darwin",
        sha256 = "7ecd2dac543dd2371a2261bda3eb5cbe72f54596b73f372671368f0ed5c77646",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/3.5.0/buildifier.mac"],
        executable = True,
    )

    http_file(
        name = "buildifier.linux",
        sha256 = "f9a9c082b8190b9260fce2986aeba02a25d41c00178855a1425e1ce6f1169843",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/3.5.0/buildifier"],
        executable = True,
    )
