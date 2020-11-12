load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_objects(
    name    = "all",
    objects = [
        ":custom-resource-definitions",
        ":cainjector",
        ":controller",
    ],
)

k8s_object(
    name     = "cainjector",
    template = ":cainjector.manifest",
    context  = None,
)

k8s_object(
    name     = "controller",
    template = ":controller.manifest",
    context  = None,
)

k8s_object(
    name     = "custom-resource-definitions",
    template = "@cert_manager_custom_resource_definitions//file",
    context  = None,
)

jsonnet_to_json(
    name = "cainjector.manifest",
    src  = "cainjector.jsonnet",
    outs = ["cainjector.json"],
    deps = ["@manifesto//lib"],
)

jsonnet_to_json(
    name = "controller.manifest",
    src  = "controller.jsonnet",
    outs = ["controller.json"],
    deps = ["@manifesto//lib"],
)
