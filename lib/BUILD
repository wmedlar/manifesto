load("@com_github_yugui_jsonnetunit//jsonnetunit:jsonnetunit.bzl", "jsonnet_test")
load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "lib",
    srcs = glob(["*.libsonnet"]),
    visibility = ["@manifesto//:__subpackages__"],
)

jsonnet_test(
    name = "apps.test",
    src = "apps.test.jsonnet",
    deps = [":lib"],
)

jsonnet_test(
    name = "core.test",
    src = "core.test.jsonnet",
    deps = [":lib"],
)

jsonnet_test(
    name = "meta.test",
    src = "meta.test.jsonnet",
    deps = [":lib"],
)

jsonnet_test(
    name = "rbac.test",
    src = "rbac.test.jsonnet",
    deps = [":lib"],
)
