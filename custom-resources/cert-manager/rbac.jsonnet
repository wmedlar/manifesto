local kube = import 'lib/kube.libsonnet';
local namespace = 'certificates';

local ClusterRoleView =
    kube.ClusterRole('%s:view' % namespace)
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
    kube.ClusterRole('%s:edit' % namespace)
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithRule(
        ['cert-manager.io'],
        ['certificates', 'certificaterequests', 'issuers'],
        ['create', 'delete', 'deletecollection', 'patch', 'update']
    )
;

kube.List([
    ClusterRoleView,
    ClusterRoleEdit,
])
