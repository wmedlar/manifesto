load("@manifesto//custom-resources/cert-manager:repos.bzl", "cert_manager_repositories")

def custom_resources_repositories():
    cert_manager_repositories()
