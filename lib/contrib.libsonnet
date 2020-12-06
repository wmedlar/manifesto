{
    local certmanager = import 'contrib/certmanager.libsonnet',
    Certificate:: certmanager.Certificate,
    ClusterIssuer:: certmanager.ClusterIssuer,
    Issuer:: certmanager.Issuer,
}
