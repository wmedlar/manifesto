local k8s = import 'lib/k8s.libsonnet';
local namespace = 'ingress';
local name = 'traefik';

local ServiceAccount = k8s.core.ServiceAccount(namespace, name);
local ClusterRole =
    k8s.rbac.ClusterRole('%s:%s' % [namespace, name])
    .WithRule([''], ['endpoints', 'secrets', 'services'], ['get', 'list', 'watch'])
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
local ClusterRoleBinding =
    k8s.rbac.ClusterRoleBinding()
    .WithRole(ClusterRole)
    .WithSubject(ServiceAccount)
;
local Deployment =
    k8s.apps.Deployment(namespace, name)
    .WithContainer(
        k8s.core.Container(name)
        .WithImage('traefik', 'v2.3.6')
        .WithArgs([
            '--accesslog=true',
            '--api=true',
            '--api.dashboard=true',
            '--entrypoints.http=true',
            '--entrypoints.http.address=:8080',
            '--entrypoints.metrics=true',
            '--entrypoints.metrics.address=:9000',
            '--metrics.prometheus=true',
            '--metrics.prometheus.entrypoint=metrics',
            '--ping=true',
            '--ping.entrypoint=metrics',
            '--providers.kubernetescrd=true',
        ])
        .WithCapabilities([])
        .WithGroupID(65532)
        .WithPort('http', 8080)
        .WithPort('metrics', 9000)
        .WithLivenessProbe(
            k8s.core.Probe()
            .WithFrequency(5)
            .WithHTTPGet('/ping', 'metrics')
        )
        .WithReadinessProbe(
            k8s.core.Probe()
            .WithFrequency(5)
            .WithHTTPGet('/ping', 'metrics')
        )
        .WithReadOnlyFilesystem()
        .WithUserID(65532)
        .WithVolumeMount('tmp', '/tmp')
    )
    .WithReplicas(1)
    .WithSelector({'app.kubernetes.io/name': name})
    .WithServiceAccount(ServiceAccount)
    .WithVolume({name: 'tmp', emptyDir: {}})
;
local Service =
    k8s.core.Service(namespace, name)
    .WithPort('http', 80, 'http')
    .WithPort('https', 443, 'http')
    .WithSelector(Deployment.spec.selector.matchLabels)
    .WithType('LoadBalancer')
    .WithSpec({externalTrafficPolicy: 'Local'})
;

k8s.core.List([
    ServiceAccount,
    ClusterRole,
    ClusterRoleBinding,
    Deployment,
    Service,
])
