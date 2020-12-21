local k8s = import 'lib/k8s.libsonnet';

local ClusterRoleView =
    k8s.rbac.ClusterRole('traefik:crd:view')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-view', 'true')
    .WithRule(
        ['traefik.containo.us'],
        [
            'ingressroutes',
            'ingressroutetcps',
            'ingressrouteudps',
            'middlewares',
            'serverstransports',
            'tlsoptions',
            'tlsstores',
            'traefikservices',
        ],
        ['get', 'list', 'watch']
    )
;
local ClusterRoleEdit =
    k8s.rbac.ClusterRole('traefik:crd:edit')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-admin', 'true')
    .WithLabel('rbac.authorization.k8s.io/aggregate-to-edit', 'true')
    .WithRule(
        ['traefik.containo.us'],
        [
            'ingressroutes',
            'ingressroutetcps',
            'ingressrouteudps',
            'middlewares',
            'serverstransports',
            'tlsoptions',
            'tlsstores',
            'traefikservices',
        ],
        ['create', 'delete', 'deletecollection', 'patch', 'update']
    )
;

k8s.core.List([
    ClusterRoleView,
    ClusterRoleEdit,
])
