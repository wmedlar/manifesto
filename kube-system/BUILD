load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_object(
    name     = "metrics-server.kube",
    template = ":metrics-server",
    context  = None,
)

jsonnet_to_json(
    name = "metrics-server",
    src  = "metrics-server.jsonnet",
    outs = ["metrics-server.json"],
    deps = ["@manifesto//lib"],
)
