load("@cert-manager//hack/bin:deps.bzl", install_hack_bin = "install")

def cert_manager_dependencies():
    install_hack_bin()
