load("@bazel_skylib//lib:paths.bzl", "paths")
load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_to_json")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")

def external_binary(name, darwin, linux, **kwargs):
    native.genrule(
        name = name,
        srcs = select({
            "@bazel_tools//src/conditions:darwin": [darwin],
            "//conditions:default": [linux],
        }),
        outs = ["bin/%s" % name],
        cmd = "mv $(SRCS) $@",
        executable = True,
        **kwargs,
    )
    return name


def k8s_json(name, src, **kwargs):
    jsonnet_to_json(
        name = name,
        src = src,
        outs = [paths.replace_extension(src, ".json")],
        deps = ["@manifesto//lib"],
        **kwargs,
    )
    return name


def k8s_manifest(name, src, **kwargs):
    if src.endswith(".jsonnet"):
        template = k8s_json("%s.template" % name, src)
    else:
        template = src

    k8s_object(
        name = name,
        template = template,
        context = None, # grants access to .apply, .delete targets
        **kwargs,
    )
    return name


def k8s_manifests(name, objects, create_namespace=False, **kwargs):
    if create_namespace:
        label = k8s_namespace("%s.namespace" % name, name)
        objects.insert(0, label)

    k8s_objects(
        name = name,
        objects = objects,
        **kwargs,
    )
    return name


def k8s_namespace(name, namespace, **kwargs):
    k8s_manifest(
        name = name,
        src = "@manifesto//lib/templates:namespace",
        substitutions = {"$name": namespace},
        **kwargs,
    )
    return name
