load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

k8s_objects(
    name    = "all",
    objects = [
        ":custom-resource-definitions",
    ],
)
k8s_object(
    name     = "custom-resource-definitions",
    template = "@cert_manager_custom_resource_definitions//file",
    context  = None,
)
