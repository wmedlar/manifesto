local apps = import 'lib/apps.libsonnet';
local core = import 'lib/core.libsonnet';
local rbac = import 'lib/rbac.libsonnet';

local namespace = 'certificates';
local name = 'cainjector';

local ServiceAccount = core.ServiceAccount(namespace, name);
local ClusterRole =
    rbac.ClusterRole('%s:%s' % [namespace, name])
    .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
    .WithRule([''], ['events'], ['create', 'get', 'patch', 'update'])
    .WithRule(['admissionregistration.k8s.io'], ['validatingwebhookconfigurations', 'mutatingwebhookconfigurations'], ['get', 'list', 'update', 'watch'])
    .WithRule(['apiregistration.k8s.io'], ['apiservices'], ['get', 'list', 'update', 'watch'])
    .WithRule(['apiextensions.k8s.io'], ['customresourcedefinitions'], ['get', 'list', 'update', 'watch'])
    .WithRule(['auditregistration.k8s.io'], ['auditsinks'], ['get', 'list', 'update', 'watch'])
    .WithRule(['cert-manager.io'], ['certificates'], ['get', 'list', 'watch'])
;
local ClusterRoleBinding =
    rbac.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local Deployment =
    apps.Deployment(namespace, name)
    .WithContainer(
        core.Container(name)
        .WithImage('quay.io/jetstack/cert-manager-cainjector', 'v1.0.4')
        .WithArg('--leader-elect=false')
    )
    .WithReplicas(1)
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
    .WithStrategy('Recreate')
;

core.List().WithItems([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Deployment,
])
