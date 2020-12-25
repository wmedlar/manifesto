local k8s = import 'lib/k8s.libsonnet';
local namespace = 'loadbalancing';
local name = 'controller';

local ServiceAccount = k8s.core.ServiceAccount(namespace, name);
local ClusterRole =
    k8s.rbac.ClusterRole('%s:%s' % [namespace, name])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule([''], ['services'], ['get', 'list', 'update', 'watch'])
    .WithRule([''], ['services/status'], ['update'])
;
local ClusterRoleBinding =
    k8s.rbac.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local Role =
    k8s.rbac.Role(namespace, name)
    .WithRule([''], ['configmaps'], ['get', 'list', 'watch'])
;
local RoleBinding =
    k8s.rbac.RoleBinding(namespace)
    .WithRole(Role)
    .WithSubject(ServiceAccount)
;
local Deployment =
    k8s.apps.Deployment(namespace, name)
    .WithContainer(
        k8s.core.Container(name)
        .WithImage('metallb/controller', 'v0.9.5')
        .WithArgs([
            '--config=metallb',
            '--port=9000',
        ])
        .WithCapabilities(drop=['all'])
        .WithGroupID(65534)
        .WithPort('metrics', 9000)
        .WithReadOnlyFilesystem()
        .WithResourceLimits(cpu='100m', memory='100Mi')
        .WithResourceRequests(cpu='100m', memory='100Mi')
        .WithUserID(65534)
    )
    .WithReplicas(1)
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
;

k8s.core.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Role,
    RoleBinding,
    Deployment,
])
