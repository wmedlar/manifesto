load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_objects(
    name    = "all",
    objects = [":metrics-server"],
)

k8s_object(
    name     = "metrics-server",
    template = ":metrics-server.manifest",
    context  = None,
)

jsonnet_to_json(
    name = "metrics-server.manifest",
    src  = "metrics-server.jsonnet",
    outs = ["metrics-server.json"],
    deps = ["@manifesto//lib"],
)
