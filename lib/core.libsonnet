local meta = import 'meta.libsonnet';

{
    Group:: 'core',
    Version:: 'v1',
    Object:: meta.Object.WithAPIVersion($.Group, $.Version),

    ConfigMap:: $.Object.WithKind('ConfigMap') {
        WithBinaryData():: self {},
        WithData():: self {},
        WithImmutability():: self {},
    },

    Endpoints:: $.Object.WithKind('Endpoints') {},

    List:: $.Object.WithKind('List') {
        Map(func):: self,
        WithItems(items):: self {},
    },

    Namespace:: $.Object.WithKind('Namespace') {
        WithFinalizer(finalizer):: self {},
    },

    Secret:: $.Object.WithKind('Secret') {
        Types:: {
            Default:: self.Opaque,
            // https://kubernetes.io/docs/concepts/configuration/secret/#secret-types
            Opaque:: 'Opaque',
            BasicAuth:: 'kubernetes.io/basic-auth',
            BootstrapToken:: 'bootstrap.kubernetes.io/token',
            DockerConfig:: 'kubernetes.io/dockercfg',
            DockerConfigJson:: 'kubernetes.io/dockerconfigjson',
            ServiceAccountToken:: 'kubernetes.io/service-account-token',
            SSHAuth:: 'kubernetes.io/ssh-auth',
            TLS:: 'kubernetes.io/tls',
        },
        WithData(key, value):: self {},
        WithStringData(key, value):: self {},
        WithImmutability(value=true):: self {},
        WithType(type):: self {},
    },

    Service:: $.Object.WithKind('Service') {
        Types:: {
            Default: self.ClusterIP,
            // https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
            ClusterIP:: 'ClusterIP',
            ExternalName:: 'ExternalName',
            LoadBalancer:: 'LoadBalancer',
            NodePort:: 'NodePort',
        },

        WithAllocateLoadBalancerNodePorts(value=true):: self {},
        WithClusterIP(ip):: self {},
        WithExternalIP(ip):: self {},
        WithExternalName(name):: self {},
        WithExternalTrafficPolicy(policy):: self {},
        WithHealthCheckNodePort(port):: self {},
        WithIPFamily(family):: self {},
        WithIPFamilyPolicy(policy):: self {},
        WithLoadBalancerIP(ip):: self {},
        WithLoadBalancerSourceRange(range):: self {},
        WithPort(func):: self {},
        WithPublishNotReadyAddresses(value=true):: self {},
        WithSelector(labels):: self {},
        WithSessionAffinity(affinity):: self {},
        // WithSessionAffinityConfig
        WithTopologyKey(key):: self {},
        WithType(type):: self {},
    },

    ServiceAccount:: $.Object.WithKind('ServiceAccount') {
        WithAutomountServiceAccountToken(value=true):: self {},
        WithImagePullSecret(name):: self {},
        // WithSecret()
    },
}
