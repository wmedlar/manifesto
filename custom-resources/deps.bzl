load("@manifesto//custom-resources/cert-manager:deps.bzl", "cert_manager_dependencies")

def custom_resources_dependencies():
    cert_manager_dependencies()
