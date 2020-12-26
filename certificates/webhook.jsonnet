local k8s = import 'lib/k8s.libsonnet';
local namespace = 'certificates';
local name = 'webhook';

// This Secret doesn't get included, it's only created here to reference throughout.
local Secret = k8s.core.Secret(namespace, '%s-ca' % name);

local ServiceAccount = k8s.core.ServiceAccount(namespace, name);
local Role =
    k8s.rbac.Role(namespace, name)
    .WithRule([''], ['secrets'], ['create'])
    .WithRule([''], ['secrets'], [Secret.metadata.name], ['get', 'list', 'update', 'watch'])
;
local RoleBinding =
    k8s.rbac.RoleBinding(namespace)
    .WithRole(Role)
    .WithSubject(ServiceAccount)
;
local Service =
    k8s.core.Service(namespace, name)
    .WithPort('https', 443, 'https')
    .WithSelector({'app.kubernetes.io/name': name})
;
local Deployment =
    k8s.apps.Deployment(namespace, name)
    .WithContainer(
        k8s.core.Container(name)
        .WithImage('quay.io/jetstack/cert-manager-webhook', 'v1.0.4')
        .WithArgs([
            '--dynamic-serving-ca-secret-name=%s' % [Secret.metadata.name],
            '--dynamic-serving-ca-secret-namespace=%s' % [Secret.metadata.namespace],
            '--dynamic-serving-dns-names=%s' % [Service.metadata.name],
            '--dynamic-serving-dns-names=%s.%s' % [Service.metadata.name, Service.metadata.namespace],
            '--dynamic-serving-dns-names=%s.%s.svc' % [Service.metadata.name, Service.metadata.namespace],
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
    .WithSelector(Service.spec.selector)
    .WithServiceAccount(ServiceAccount)
;
local MutatingWebhookConfiguration =
    k8s.admissionregistration.MutatingWebhookConfiguration(name)
    .WithAnnotation('cert-manager.io/inject-ca-from-secret', Secret.metadata.namespace + '/' + Secret.metadata.name)
    .WithWebhook(
        'webhook.cert-manager.io', function(webhook)
            webhook
            .WithAdmissionReviewVersions(['v1', 'v1beta1'])
            .WithNoSideEffects()
            .WithRule(['cert-manager.io', 'acme.cert-manager.io'], ['*'], ['*/*'], ['CREATE', 'UPDATE'])
            .WithService(Service, '/mutate')
    )
;
local ValidatingWebhookConfiguration =
    k8s.admissionregistration.ValidatingWebhookConfiguration(name)
    .WithAnnotation('cert-manager.io/inject-ca-from-secret', Secret.metadata.namespace + '/' + Secret.metadata.name)
    .WithWebhook(
        'webhook.cert-manager.io', function(webhook)
            webhook
            .WithAdmissionReviewVersions(['v1', 'v1beta1'])
            .WithNoSideEffects()
            .WithNamespaceSelector('cert-manager.io/disable-validation', 'NotIn', ['true'],)
            .WithRule(['cert-manager.io', 'acme.cert-manager.io'], ['*'], ['*/*'], ['CREATE', 'UPDATE'])
            .WithService(Service, '/validate')
    )
;

k8s.core.List([
    ServiceAccount,
    Role,
    RoleBinding,
    Service,
    Deployment,
    MutatingWebhookConfiguration,
])
