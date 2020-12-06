local contrib = import 'lib/contrib.libsonnet';
local kube = import 'lib/kube.libsonnet';
local namespace = 'certificates';

// This Secret doesn't get deployed, it's only created here to reference throughout.
local Secret = kube.Secret(namespace, 'internal-ca');

// The bootstrap Issuer is used to generate a self-signed certificate to act as a
// certificate authority and the root of trust between applications in the cluster.
local Issuer =
    contrib.Issuer(namespace, 'bootstrap')
    .WithSelfSigningCertificates()
;
local Certificate =
    contrib.Certificate(namespace, 'internal-ca')
    .WithCommonName('Manifesto Internal Authority')
    .WithDuration(years=10)
    .WithIssuer(Issuer)
    .WithSecret(Secret)
    .WithSpec({isCA: true})
;

// The bootstrapped certificate authority is used by the internal ClusterIssuer to sign
// TLS certificates for applications in the cluster.
local ClusterIssuer =
    contrib.ClusterIssuer('internal')
    .WithKeypairSecret(Secret)
;

kube.List([
    Issuer,
    Certificate,
    ClusterIssuer,
])
