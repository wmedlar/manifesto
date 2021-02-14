local k8s = import 'lib/k8s.libsonnet';
local name = 'controller';

{
    List(namespace):: (
        local clusterrole = $.ClusterRole(namespace);
        local serviceaccount = $.ServiceAccount(namespace);
        local clusterrolebinding =
            k8s.rbac.ClusterRoleBinding()
            .WithRole(clusterrole)
            .WithSubject(serviceaccount)
        ;
        local deployment = $.Deployment(namespace);

        k8s.core.List([
            clusterrole,
            serviceaccount,
            clusterrolebinding,
            deployment,
        ])
    ),

    ClusterRole(namespace):: (
        k8s.rbac.ClusterRole('%s:%s' % [namespace, name])
        // certificates controller
        .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
        .WithRule([''], ['events'], ['create', 'patch'])
        .WithRule(['acme.cert-manager.io'], ['orders'], ['create', 'delete', 'get', 'list', 'watch'])
        .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'clusterissuers', 'issuers'], ['get', 'list', 'watch'])
        .WithRule(['cert-manager.io'], ['certificates', 'certificates/status', 'certificaterequests', 'certificaterequests/status'], ['update'])
        .WithRule(['cert-manager.io'], ['certificates/finalizers', 'certificaterequests/finalizers'], ['update'])
        // challenges controller
        .WithRule([''], ['pods', 'services'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
        .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
        .WithRule([''], ['events'], ['create', 'patch'])
        .WithRule(['extensions', 'networking.k8s.io'], ['ingresses'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
        .WithRule(['acme.cert-manager.io'], ['challenges'], ['get', 'list', 'watch'])
        .WithRule(['acme.cert-manager.io'], ['challenges', 'challenges/status', 'challenges/finalizers'], ['update'])
        .WithRule(['cert-manager.io'], ['clusterissuers', 'issuers'], ['get', 'list', 'watch'])
        // clusterissuers controller
        .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
        .WithRule([''], ['events'], ['create', 'patch'])
        .WithRule(['cert-manager.io'], ['clusterissuers'], ['get', 'list', 'watch'])
        .WithRule(['cert-manager.io'], ['clusterissuers', 'clusterissuers/status'], ['update'])
        // ingress-shim controller (disabled)
        // .WithRule([''], ['events'], ['create', 'patch'])
        // .WithRule(['extensions', 'networking.k8s.io'], ['ingresses'], ['get', 'list', 'watch'])
        // .WithRule(['extensions', 'networking.k8s.io'], ['ingresses/finalizers'], ['update'])
        // .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests'], ['create', 'update', 'delete'])
        // .WithRule(['cert-manager.io'], ['certificates', 'certificaterequests', 'clusterissuers', 'issuers'], ['get', 'list', 'watch'])
        // issuers controller
        .WithRule([''], ['secrets'], ['create', 'delete', 'get', 'list', 'update', 'watch'])
        .WithRule([''], ['events'], ['create', 'patch'])
        .WithRule(['cert-manager.io'], ['issuers'], ['get', 'list', 'watch'])
        .WithRule(['cert-manager.io'], ['issuers', 'issuers/status'], ['update'])
        // orders controller
        .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
        .WithRule([''], ['events'], ['create', 'patch'])
        .WithRule(['acme.cert-manager.io'], ['challenges', 'orders'], ['get', 'list', 'watch'])
        .WithRule(['acme.cert-manager.io'], ['challenges'], ['create', 'delete'])
        .WithRule(['acme.cert-manager.io'], ['orders', 'orders/status'], ['update'])
        .WithRule(['acme.cert-manager.io'], ['orders/finalizers'], ['update'])
        .WithRule(['cert-manager.io'], ['clusterissuers', 'issuers'], ['get', 'list', 'watch'])
    ),

    Deployment(namespace):: (
        k8s.apps.Deployment(namespace, name)
        .WithContainer(
            k8s.core.Container(name)
            .WithImage('quay.io/jetstack/cert-manager-controller', 'v1.0.4')
            .WithArgs([
                '--cluster-resource-namespace=$(POD_NAMESPACE)',
                // Disable unused controllers to reduce resource usage and apiserver load.
                // Disabled controllers have been commented out.
                '--controllers=' + std.join(',', [
                    'challenges',
                    'clusterissuers',
                    // 'ingress-shim',
                    'issuers',
                    'orders',
                    // 'certificaterequests-issuer-acme',
                    'certificaterequests-issuer-ca',
                    'certificaterequests-issuer-selfsigned',
                    // 'certificaterequests-issuer-vault',
                    // 'certificaterequests-issuer-venafi',
                    'CertificateIssuing',
                    'CertificateKeyManager',
                    'CertificateMetrics',
                    'CertificateRequestManager',
                    'CertificateReadiness',
                    'CertificateTrigger',
                ]),
                '--enable-certificate-owner-ref=true',
                '--leader-elect=false',
            ])
            .WithEnvFromField('POD_NAMESPACE', 'metadata.namespace')
            .WithPort('metrics', 9042)
        )
        .WithReplicas(1)
        .WithSelector({'app.kubernetes.io/name': name})
        .WithServiceAccountName(name)
        .WithStrategy('Recreate')
    ),

    ServiceAccount(namespace):: k8s.core.ServiceAccount(namespace, name),
}
