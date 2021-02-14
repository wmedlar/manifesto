load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")

jsonnet_to_json(
    name = "namespace",
    src = "namespace.jsonnet",
    outs = ["namespace.tmpl.json"],
    deps = ["@manifesto//lib"],
    visibility = ["@manifesto//:__subpackages__"],
)
