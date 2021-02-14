local k8s = import 'lib/k8s.libsonnet';
local name = 'cainjector';

{
    List(namespace):: (
        local clusterrole = $.ClusterRole(namespace);
        local serviceaccount = $.ServiceAccount(namespace);
        local clusterrolebinding =
            k8s.rbac.ClusterRoleBinding()
            .WithRole(clusterrole)
            .WithSubject(serviceaccount)
        ;
        local deployment = $.Deployment(namespace);

        k8s.core.List([
            clusterrole,
            serviceaccount,
            clusterrolebinding,
            deployment,
        ])
    ),

    ClusterRole(namespace):: (
        k8s.rbac.ClusterRole('%s:%s' % [namespace, name])
        .WithRule([''], ['secrets'], ['get', 'list', 'watch'])
        .WithRule([''], ['events'], ['create', 'get', 'patch', 'update'])
        .WithRule(['admissionregistration.k8s.io'], ['validatingwebhookconfigurations', 'mutatingwebhookconfigurations'], ['get', 'list', 'update', 'watch'])
        .WithRule(['apiregistration.k8s.io'], ['apiservices'], ['get', 'list', 'update', 'watch'])
        .WithRule(['apiextensions.k8s.io'], ['customresourcedefinitions'], ['get', 'list', 'update', 'watch'])
        .WithRule(['auditregistration.k8s.io'], ['auditsinks'], ['get', 'list', 'update', 'watch'])
        .WithRule(['cert-manager.io'], ['certificates'], ['get', 'list', 'watch'])
    ),

    Deployment(namespace):: (
        k8s.apps.Deployment(namespace, name)
        .WithContainer(
            k8s.core.Container(name)
            .WithImage('quay.io/jetstack/cert-manager-cainjector', 'v1.0.4')
            .WithArg('--leader-elect=false')
        )
        .WithReplicas(1)
        .WithSelector({'app.kubernetes.io/name': name})
        .WithServiceAccountName(name)
        .WithStrategy('Recreate')
    ),

    ServiceAccount(namespace):: k8s.core.ServiceAccount(namespace, name),
}
