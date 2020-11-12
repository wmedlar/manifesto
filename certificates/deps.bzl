load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def certificates_dependencies():
    http_file(
        name = "cert_manager_custom_resource_definitions",
        urls = ["https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml"],
        sha256 = "d83aa047f7c0b9495fecddfe6bdaea96d20b07544f15f3067747229e4890d4ce",
        downloaded_file_path = "cert-manager.crds.yaml"
    )
