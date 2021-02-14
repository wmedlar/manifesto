local k8s = import 'lib/k8s.libsonnet';
local name = 'webhook';
local secretName = name + '-tls';

{
    List(namespace):: (
        local role = $.Role(namespace);
        local serviceaccount = $.ServiceAccount(namespace);
        local rolebinding =
            k8s.rbac.RoleBinding(namespace)
            .WithRole(role)
            .WithSubject(serviceaccount)
        ;
        local deployment = $.Deployment(namespace);
        local service = $.Service(namespace);
        local mutatingwebhook = $.MutatingWebhookConfiguration(namespace);
        local validatingwebhook = $.ValidatingWebhookConfiguration(namespace);

        k8s.core.List([
            role,
            serviceaccount,
            rolebinding,
            deployment,
            service,
            mutatingwebhook,
            validatingwebhook,
        ])
    ),

    Role(namespace):: (
        k8s.rbac.Role(namespace, name)
        .WithRule([''], ['secrets'], ['create'])
        .WithRule([''], ['secrets'], [secretName], ['get', 'list', 'update', 'watch'])
    ),

    Deployment(namespace):: (
        k8s.apps.Deployment(namespace, name)
        .WithContainer(
            k8s.core.Container(name)
            .WithImage('quay.io/jetstack/cert-manager-webhook', 'v1.0.4')
            .WithArgs([
                '--dynamic-serving-ca-secret-name=%s' % secretName,
                '--dynamic-serving-ca-secret-namespace=%s' % namespace,
                '--dynamic-serving-dns-names=%s' % name,
                '--dynamic-serving-dns-names=%s.%s' % [name, namespace],
                '--dynamic-serving-dns-names=%s.%s.%s' % [name, namespace, 'svc'],
                '--healthz-port=8080',
                '--secure-port=8443',
            ])
            .WithPort('http', 8080)
            .WithPort('https', 8443)
            .WithLivenessProbe(
                k8s.core.Probe()
                .WithDelay(60)
                .WithHTTPGet('/livez', 'http')
            )
            .WithReadinessProbe(
                k8s.core.Probe()
                .WithDelay(5)
                .WithFrequency(5)
                .WithHTTPGet('/healthz', 'http')
            )
        )
        .WithReplicas(1)
        .WithSelector({'app.kubernetes.io/name': name})
        .WithServiceAccountName(name)
    ),

    MutatingWebhookConfiguration(namespace):: (
        k8s.admissionregistration.MutatingWebhookConfiguration('%s.%s.will.md' % [name, namespace])
        .WithAnnotation('cert-manager.io/inject-ca-from-secret', namespace + '/' + secretName)
        .WithNoSideEffects()
        .WithRule(['cert-manager.io', 'acme.cert-manager.io'], ['*'], ['*/*'], ['CREATE', 'UPDATE'])
        .WithService({metadata: {namespace: namespace, name: name}}, '/mutate')
        .WithVersions(['v1', 'v1beta1'])
    ),

    Service(namespace):: (
        k8s.core.Service(namespace, name)
        .WithPort('https', 443, 'https')
        .WithSelector({'app.kubernetes.io/name': name})
    ),

    ServiceAccount(namespace):: k8s.core.ServiceAccount(namespace, name),

    ValidatingWebhookConfiguration(namespace):: (
        k8s.admissionregistration.ValidatingWebhookConfiguration('%s.%s.will.md' % [name, namespace])
        .WithAnnotation('cert-manager.io/inject-ca-from-secret', namespace + '/' + secretName)
        .WithNamespaceSelector('cert-manager.io/disable-validation', 'NotIn', ['true'])
        .WithNoSideEffects()
        .WithObjectSelector('cert-manager.io/disable-validation', 'NotIn', ['true'])
        .WithRule(['cert-manager.io', 'acme.cert-manager.io'], ['*'], ['*/*'], ['CREATE', 'UPDATE'])
        .WithService({metadata: {namespace: namespace, name: name}}, '/validate')
        .WithVersions(['v1', 'v1beta1'])
    ),
}
