{
    apiregistration: import 'api/apiregistration.libsonnet',
    apps: import 'api/apps.libsonnet',
    core: import 'api/core.libsonnet',
    meta: import 'api/meta.libsonnet',
    rbac: import 'api/rbac.libsonnet',
    ext: {
        certmanager: import 'ext/certmanager.libsonnet',
    },
}
