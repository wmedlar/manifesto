local core = import 'lib/core.libsonnet';
local rbac = import 'lib/rbac.libsonnet';

local namespace = 'certificates';

local ClusterRoleView =
    rbac.ClusterRole('%s:view' % namespace)
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-view', 'true')
    .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'issuers'], ['get', 'list', 'watch'])
;
local ClusterRoleEdit =
    rbac.ClusterRole('%s:edit' % namespace)
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'issuers'], ['create', 'delete', 'deletecollection', 'patch', 'update'])
;

core.List([
    ClusterRoleView,
    ClusterRoleEdit,
])
