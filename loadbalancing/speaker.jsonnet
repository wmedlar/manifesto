local k8s = import 'lib/k8s.libsonnet';
local namespace = 'loadbalancing';
local name = 'speaker';

local ServiceAccount = k8s.core.ServiceAccount(namespace, name);
local ClusterRole =
    k8s.rbac.ClusterRole('%s:%s' % [namespace, name])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule([''], ['endpoints', 'nodes', 'services'], ['get', 'list', 'watch'])
;
local ClusterRoleBinding =
    k8s.rbac.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local Role =
    k8s.rbac.Role(namespace, name)
    .WithRule([''], ['configmaps'], ['get', 'list', 'watch'])
    .WithRule([''], ['pods'], ['list'])
;
local RoleBinding =
    k8s.rbac.RoleBinding(namespace)
    .WithRole(Role)
    .WithSubject(ServiceAccount)
;
local DaemonSet =
    k8s.apps.DaemonSet(namespace, name)
    .WithContainer(
        k8s.core.Container(name)
        .WithImage('metallb/speaker', 'v0.9.5')
        .WithArgs([
            '--config=metallb',
            '--port=9000',
        ])
        .WithCapabilities(
            add=['net_raw'],
            drop=['all'],
        )
        .WithEnv('METALLB_ML_BIND_PORT', '7946')
        .WithEnv('METALLB_ML_LABELS', 'app.kubernetes.io/name=%s' % name)
        .WithEnv('METALLB_ML_SECRET_KEY', '3KEZjKGoIV9ihLligSQgXw==')
        .WithEnvFromField('METALLB_HOST', 'status.hostIP')
        .WithEnvFromField('METALLB_ML_BIND_ADDR', 'status.podIP')
        .WithEnvFromField('METALLB_ML_NAMESPACE', 'metadata.namespace')
        .WithEnvFromField('METALLB_NODE_NAME', 'spec.nodeName')
        .WithPort('metrics', 9000)
        .WithReadOnlyFilesystem()
        .WithResourceLimits(cpu='100m', memory='100Mi')
        .WithResourceRequests(cpu='100m', memory='100Mi')
    )
    .WithHostNetworking()
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
;

k8s.core.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Role,
    RoleBinding,
    DaemonSet,
])
