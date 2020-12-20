local k8s = import 'lib/k8s.libsonnet';
local namespace = 'certificates';

// This Secret doesn't get deployed, it's only created here to reference throughout.
local Secret = k8s.core.Secret(namespace, 'internal-ca');

// The bootstrap Issuer is used to generate a self-signed certificate to act as a
// certificate authority and the root of trust between applications in the cluster.
local Issuer =
    k8s.ext.certmanager.Issuer(namespace, 'bootstrap')
    .WithSelfSigningCertificates()
;
local Certificate =
    k8s.ext.certmanager.Certificate(namespace, 'internal-ca')
    .WithCommonName('Manifesto Internal Authority')
    .WithDuration(years=10)
    .WithIssuer(Issuer)
    .WithSecret(Secret)
    .WithSpec({isCA: true})
;

// The bootstrapped certificate authority is used by the internal ClusterIssuer to sign
// TLS certificates for applications in the cluster.
local ClusterIssuer =
    k8s.ext.certmanager.ClusterIssuer('internal')
    .WithKeypairSecret(Secret)
;

k8s.core.List([
    Issuer,
    Certificate,
    ClusterIssuer,
])
