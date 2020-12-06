load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

def k8s_manifests(name, src = None, substitutions = None, visibility = None):
    if src == None:
        src = "%s.jsonnet" % name

    if src.endswith(".jsonnet"):
        label = "%s.manifest" % name

        jsonnet_to_json(
            name = label,
            src = src,
            outs = ["%s.json" % name],
            deps = ["//lib"],
            visibility = ["//visibility:private"],
        )
    else:
        label = src

    k8s_object(
        name = name,
        context = None,
        template = label,
        substitutions = substitutions,
        visibility = visibility,
    )

def k8s_namespace(name, namespace, visibility = None):
    k8s_object(
        name = name,
        context = None,
        template = "@manifesto//templates:namespace",
        substitutions = {"$name": namespace},
        visibility = visibility,
    )
