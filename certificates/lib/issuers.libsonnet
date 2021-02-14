local k8s = import 'lib/k8s.libsonnet';
local name = 'internal';

{
    List(namespace):: (
        k8s.core.List([
            $.BootstrapIssuer,
            $.InternalIssuerCertificate,
            $.InternalIssuer,
        ]).WithNamespace(namespace)
    ),

    BootstrapIssuer:: (
        k8s.ext.certmanager.Issuer(null, '%s-bootstrap' % name)
        .WithSelfSigningCertificates()
    ),

    InternalIssuerCertificate:: (
        k8s.ext.certmanager.Certificate(null, '%s-ca' % name)
        .WithCommonName('Manifesto Internal Authority')
        .WithDuration(years=10)
        .WithSecret($.InternalIssuerKeypair)
        .WithSpec({isCA: true})
    ),

    InternalIssuerKeypair:: (
        k8s.core.Secret(null, '%s-ca' % name)
    ),

    InternalIssuer:: (
        k8s.ext.certmanager.ClusterIssuer(name)
        .WithKeypairSecret($.InternalIssuerKeypair)
    ),
}
