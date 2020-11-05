load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "lib",
    srcs = glob(["*.libsonnet"]),
    visibility = ["@manifesto//:__subpackages__"],
)
