local k8s = import 'lib/k8s.libsonnet';

local group = 'cert-manager.io';
local version = 'v1';

local object(kind, namespace, name) =
    k8s.meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    Certificate(namespace, name):: object('Certificate', namespace, name) {
        ForService(service, domain='cluster.local')::
            local dnsNames = [
                service.metadata.name,
                std.join('.', [service.metadata.name, service.metadata.namespace]),
                std.join('.', [service.metadata.name, service.metadata.namespace, 'svc']),
                std.join('.', [service.metadata.name, service.metadata.namespace, 'svc', domain]),
            ];
            self.WithDNSNames(dnsNames),

        WithCommonName(name)::
            self + {spec+: {commonName: name}},

        WithDNSNames(names)::
            self + {spec+: {dnsNames: names}},

        WithDuration(days=0, years=0)::
            local hours = 24 * (days + (365 * years));
            self + {spec+: {duration: '%sh' % hours}},

        WithIssuer(issuer)::
            self + {spec+: {issuerRef: {
                group: std.split(issuer.apiVersion, '/')[0],
                kind: issuer.kind,
                name: issuer.metadata.name,
            }}},

        WithSecret(secret)::
            self + {spec+: {secretName: secret.metadata.name}},

        WithSecretName(name)::
            self + {spec+: {secretName: name}},
    },

    ClusterIssuer(name):: object('ClusterIssuer', null, name) {
        WithKeypairSecret(secret)::
            self + {spec+: {ca+: {secretName: secret.metadata.name}}},

        WithKeypairSecretName(name)::
            self + {spec+: {ca+: {secretName: name}}},

        WithSelfSigningCertificates()::
            self + {spec+: {selfSigned+: {}}},
    },

    Issuer(namespace, name):: $.ClusterIssuer(null) + object('Issuer', namespace, name),
}
