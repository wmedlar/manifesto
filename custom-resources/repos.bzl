load("@manifesto//custom-resources/cert-manager:repos.bzl", "cert_manager_repositories")
load("@manifesto//custom-resources/traefik:repos.bzl", "traefik_repositories")

def custom_resources_repositories():
    cert_manager_repositories()
    traefik_repositories()
