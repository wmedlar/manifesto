load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

traefik_build_file = """
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

copy_file(
    name = "crds",
    src = "docs/content/reference/dynamic-configuration/kubernetes-crd-definition.yml",
    out = "crds.yaml",
    visibility = ["//visibility:public"],
)
"""

def traefik_repositories():
    http_archive(
        name = "traefik",
        sha256 = "9b7ca4b31f53487ac35b34210d045af6e00e3c09e0ac2ec794d16c2a48f72969",
        strip_prefix = "traefik-2.3.6",
        urls = ["https://github.com/traefik/traefik/archive/v2.3.6.tar.gz"],
        build_file_content = traefik_build_file,
    )
