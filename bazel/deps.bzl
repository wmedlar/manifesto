load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")
load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_dependencies = "deps")
load("@jsonnet_go//bazel:repositories.bzl", "jsonnet_go_repositories")
load("@jsonnet_go//bazel:deps.bzl", "jsonnet_go_dependencies")
load("@manifesto//custom-resources:deps.bzl", "custom_resources_dependencies")

def manifesto_dependencies():
    # package dependencies
    jsonnet_go_repositories()
    jsonnet_go_dependencies()
    k8s_repositories()
    k8s_go_dependencies()

    # subpackage dependencies
    custom_resources_dependencies()
