local k8s = import 'lib/k8s.libsonnet';
local namespace = 'certificates';

local ClusterRoleView =
    k8s.rbac.ClusterRole('%s:view' % namespace)
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-view', 'true')
    .WithRule(
        ['cert-manager.io'],
        ['certificates', 'certificaterequests', 'issuers'],
        ['get', 'list', 'watch']
    )
;
local ClusterRoleEdit =
    k8s.rbac.ClusterRole('%s:edit' % namespace)
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithRule(
        ['cert-manager.io'],
        ['certificates', 'certificaterequests', 'issuers'],
        ['create', 'delete', 'deletecollection', 'patch', 'update']
    )
;

k8s.core.List([
    ClusterRoleView,
    ClusterRoleEdit,
])
