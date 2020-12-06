local kube = import 'lib/kube.libsonnet';
local namespace = 'certificates';
local name = 'controller';

local ServiceAccount = kube.ServiceAccount(namespace, name);
local ClusterRole =
    kube.ClusterRole('%s:%s' % [namespace, name])
    .WithAggregationSelector({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
;
local ClusterRoleBinding =
    kube.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local AggregatedClusterRoles = [
    kube.ClusterRole('%s:%s:issuers' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['cert-manager.io'], ['issuers'], ['get', 'list', 'watch'])
    .WithRule(['cert-manager.io'], ['issuers', 'issuers/status'], ['update']),

    kube.ClusterRole('%s:%s:clusterissuers' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['cert-manager.io'], ['clusterissuers'], ['get', 'list', 'watch'])
    .WithRule(['cert-manager.io'], ['clusterissuers', 'clusterissuers/status'], ['update']),

    kube.ClusterRole('%s:%s:certificates' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['acme.cert-manager.io'], ['orders'], ['create', 'delete', 'get', 'list', 'watch'])
    .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'clusterissuers', 'issuers'], ['get', 'list', 'watch'])
    .WithRule(['cert-manager.io'], ['certificates', 'certificates/status', 'certificaterequests', 'certificaterequests/status'], ['update'])
    .WithRule(['cert-manager.io'], ['certificates/finalizers', 'certificaterequests/finalizers'], ['update']),

    kube.ClusterRole('%s:%s:orders' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['acme.cert-manager.io'], ['challenges', 'orders'], ['get', 'list', 'watch'])
    .WithRule(['acme.cert-manager.io'], ['challenges'], ['create', 'delete'])
    .WithRule(['acme.cert-manager.io'], ['orders', 'orders/status'], ['update'])
    .WithRule(['acme.cert-manager.io'], ['orders/finalizers'], ['update'])
    .WithRule(['cert-manager.io'], ['clusterissuers', 'issuers'], ['get', 'list', 'watch']),

    kube.ClusterRole('%s:%s:challenges' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['pods', 'services'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
    .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['extensions', 'networking.k8s.io'], ['ingresses'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
    .WithRule(['acme.cert-manager.io'], ['challenges'], ['get', 'list', 'watch'])
    .WithRule(['acme.cert-manager.io'], ['challenges', 'challenges/status', 'challenges/finalizers'], ['update'])
    .WithRule(['cert-manager.io'], ['clusterissuers', 'issuers'], ['get', 'list', 'watch']),

    kube.ClusterRole('%s:%s:ingress-shim' % [namespace, name])
    .WithLabels({'rbac.certificates.manifesto/aggregate-to-controller': 'true'})
    .WithRule([''], ['events'], ['create', 'patch'])
    .WithRule(['extensions', 'networking.k8s.io'], ['ingresses'], ['get', 'list', 'watch'])
    .WithRule(['extensions', 'networking.k8s.io'], ['ingresses/finalizers'], ['update'])
    .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests'], ['create', 'update', 'delete'])
    .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'clusterissuers', 'issuers'], ['get', 'list', 'watch']),
];
local Deployment =
    kube.Deployment(namespace, name)
    .WithContainer(
        kube.Container(name)
        .WithImage('quay.io/jetstack/cert-manager-controller', 'v1.0.4')
        .WithArgs([
            '--cluster-resource-namespace=$(POD_NAMESPACE)',
            '--enable-certificate-owner-ref',
            '--leader-elect=false',
        ])
        .WithEnvFromField('POD_NAMESPACE', 'metadata.namespace')
        .WithPort('metrics', 9042)
    )
    .WithReplicas(1)
    .WithStrategy('Recreate')
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
;
local Service =
    kube.Service(namespace, name)
    .WithPort('metrics', 9042)
    .WithSelector(Deployment.spec.selector.matchLabels)
;

kube.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Deployment,
    Service,
] + AggregatedClusterRoles)
