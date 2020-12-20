local k8s = import 'lib/k8s.libsonnet';
local namespace = 'kube-system';
local name = 'metrics-server';

local ServiceAccount = k8s.core.ServiceAccount(namespace, name);
local ClusterRole =
    k8s.rbac.ClusterRole('system:%s' % name)
    .WithRule([''], ['configmaps', 'namespaces', 'nodes', 'nodes/stats', 'pods'], ['get', 'list', 'watch'])
    .WithRule(['authentication.k8s.io'], ['tokenreviews'], ['create'])
    .WithRule(['authorization.k8s.io'], ['subjectaccessreviews'], ['create'])
;
local ClusterRoleBinding =
    k8s.rbac.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local RoleBinding =
    k8s.rbac.RoleBinding(namespace, 'system:%s' % name)
    .WithRole(k8s.rbac.Role(namespace, 'extension-apiserver-authentication-reader'))
    .WithSubject(ServiceAccount)
;
local Certificate =
    k8s.ext.certmanager.Certificate(namespace, name)
    .WithDNSNames([
        name,
        '%s.%s.svc' % [name, namespace],
        '%s.%s.svc.cluster.local' % [name, namespace],
    ])
    .WithDuration(days=30)
    .WithIssuer(k8s.ext.certmanager.ClusterIssuer('internal'))
    .WithSecretName('%s-tls' % name)
;
local Deployment =
    k8s.apps.Deployment(namespace, name)
    .WithContainer(
        k8s.core.Container(name)
        .WithImage('k8s.gcr.io/metrics-server/metrics-server', 'v0.3.7')
        .WithArgs([
            '--kubelet-preferred-address-types=InternalIP',
            '--secure-port=6443',
            '--tls-cert-file=/certs/tls.crt',
            '--tls-private-key-file=/certs/tls.key',
        ])
        .WithPort('https', 6443)
        .WithReadOnlyFilesystem()
        .WithUser(1000)
        .WithVolumeMount('tls', '/certs')
        .WithVolumeMount('tmp', '/tmp')
    )
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
    .WithVolume({name: 'tls', secret: {secretName: Certificate.spec.secretName}})
    .WithVolume({name: 'tmp', emptyDir: {}})
;
local Service =
    k8s.core.Service(namespace, name)
    .WithLabel('kubernetes.io/cluster-service', 'true')
    .WithLabel('kubernetes.io/name', name)
    .WithPort('https', 443, 6443)
    .WithSelector(Deployment.spec.selector.matchLabels)
;
local APIService =
    k8s.apiregistration.APIService('metrics.k8s.io', 'v1beta1')
    .WithAnnotation('cert-manager.io/inject-ca-from', Certificate.metadata.namespace + '/' + Certificate.metadata.name)
    .WithPriority(100)
    .WithService(Service)
;

k8s.core.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Certificate,
    Deployment,
    Service,
    APIService,
])
