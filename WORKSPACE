workspace(name = "manifesto")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_jsonnet",
    sha256 = "7f51f859035cd98bcf4f70dedaeaca47fe9fbae6b199882c516d67df416505da",
    strip_prefix = "rules_jsonnet-0.3.0",
    urls = ["https://github.com/bazelbuild/rules_jsonnet/archive/0.3.0.tar.gz"],
)

load("@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_repositories")
jsonnet_repositories()

load("@jsonnet_go//bazel:repositories.bzl", "jsonnet_go_repositories")
jsonnet_go_repositories()

load("@jsonnet_go//bazel:deps.bzl", "jsonnet_go_dependencies")
jsonnet_go_dependencies()

git_repository(
    name = "com_github_yugui_jsonnetunit",
    remote = "https://github.com/yugui/jsonnetunit.git",
    tag = "v0.2.0",
)

http_archive(
    name = "io_bazel_rules_k8s",
    strip_prefix = "rules_k8s-0.6",
    urls = ["https://github.com/bazelbuild/rules_k8s/archive/v0.6.tar.gz"],
    sha256 = "51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef",
)

load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")
k8s_repositories()

load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_dependencies = "deps")
k8s_go_dependencies()

load("@manifesto//custom-resources:repos.bzl", "custom_resources_repositories")
custom_resources_repositories()

load("@manifesto//custom-resources:deps.bzl", "custom_resources_dependencies")
custom_resources_dependencies()
