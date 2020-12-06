local kube = import 'lib/kube.libsonnet';
local namespace = 'kube-system';
local name = 'metrics-server';

local ServiceAccount = kube.ServiceAccount(namespace, name);
local ClusterRole =
    kube.ClusterRole('system:%s' % name)
    .WithRule([''], ['configmaps', 'namespaces', 'nodes', 'nodes/stats', 'pods'], ['get', 'list', 'watch'])
    .WithRule(['authentication.k8s.io'], ['tokenreviews'], ['create'])
    .WithRule(['authorization.k8s.io'], ['subjectaccessreviews'], ['create'])
;
local ClusterRoleBinding =
    kube.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local RoleBinding =
    kube.RoleBinding(namespace, 'system:%s' % name)
    .WithRole(kube.Role(namespace, 'extension-apiserver-authentication-reader'))
    .WithSubject(ServiceAccount)
;
local Deployment =
    kube.Deployment(namespace, name)
    .WithContainer(
        kube.Container(name)
        .WithImage('k8s.gcr.io/metrics-server/metrics-server', 'v0.3.7')
        .WithArgs([
            '--cert-dir=/tmp',
            '--kubelet-preferred-address-types=InternalIP',
            '--secure-port=6443',
        ])
        .WithPort('https', 6443)
        .WithReadOnlyFilesystem()
        .WithUser(1000)
        .WithVolumeMount('tmp', '/tmp')
    )
    .WithEmptyVolume('tmp')
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
;
local Service =
    kube.Service(namespace, name)
    .WithLabel('kubernetes.io/cluster-service', 'true')
    .WithLabel('kubernetes.io/name', name)
    .WithPort('https', 443, 6443)
    .WithSelector(Deployment.spec.selector.matchLabels)
;
local APIService =
    kube.APIService('metrics.k8s.io', 'v1beta1')
    .WithInsecureTLS()
    .WithPriority(100)
    .WithService(Service)
;

kube.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Deployment,
    Service,
    APIService,
])
