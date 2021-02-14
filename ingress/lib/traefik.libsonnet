local manifesto = import 'lib/manifesto.libsonnet';
local name = 'traefik';

{
    List(namespace):: (
        manifesto.List
        .WithItem(
            manifesto.ServiceAccount
            .WithName(name)
        )
        .WithItem(
            manifesto.ClusterRole
            .WithName('%s:%s' % [namespace, name])
        )
        .WithItem(
            manifesto.ClusterRoleBinding
            .WithName('%s:%s' % [namespace, name])
            .WithClusterRole('%s:%s' % [namespace, name])
            .WithServiceAccount(name, namespace)
        )
        .WithItem(
            manifesto.Service
            .WithName(name)
            .WithPort('http', 80)
            .WithPort('https', 443)
            .WithSelector({})
            .WithType(manifesto.Service.Types.LoadBalancer)
        )
        .Map(function(item) item.WithNamespace(namespace))
    )
}
