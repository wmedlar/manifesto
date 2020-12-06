local kube = import 'lib/kube.libsonnet';

local group = 'cert-manager.io';
local version = 'v1';

local object(kind, namespace, name) =
    kube.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    Certificate(namespace, name):: object('Certificate', namespace, name) {
        spec+: {secretName: name},

        WithCommonName(name)::
            self + {spec+: {commonName: name}},

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
    },

    ClusterIssuer(name):: object('ClusterIssuer', null, name) {
        WithKeypairSecret(secret)::
            self + {spec+: {ca+: {secretName: secret.metadata.name}}},

        WithSelfSigningCertificates()::
            self + {spec+: {selfSigned+: {}}},
    },

    Issuer(namespace, name):: $.ClusterIssuer(null) + object('Issuer', namespace, name),
}
