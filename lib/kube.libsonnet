{
    local apiregistration = import 'kube/apiregistration.libsonnet',
    APIService:: apiregistration.APIService,

    local apps = import 'kube/apps.libsonnet',
    DaemonSet:: apps.DaemonSet,
    Deployment:: apps.Deployment,

    local core = import 'kube/core.libsonnet',
    Container:: core.Container,
    List:: core.List,
    Namespace:: core.Namespace,
    Probe:: core.Probe,
    Secret:: core.Secret,
    Service:: core.Service,
    ServiceAccount:: core.ServiceAccount,

    local meta = import 'kube/meta.libsonnet',
    Object:: meta.Object,

    local rbac = import 'kube/rbac.libsonnet',
    ClusterRole:: rbac.ClusterRole,
    ClusterRoleBinding:: rbac.ClusterRoleBinding,
    Role:: rbac.Role,
    RoleBinding:: rbac.RoleBinding,
}
