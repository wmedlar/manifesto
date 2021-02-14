local meta = import 'meta.libsonnet';

{
    Group:: 'rbac.authorization.k8s.io',
    Version:: 'v1',
    Object:: meta.Object.WithAPIVersion($.Group, $.Version),

    ClusterRole:: $.Role.WithKind('ClusterRole'),

    ClusterRoleBinding:: $.RoleBinding.WithKind('ClusterRoleBinding') {
        // WithRole is not supported for ClusterRoleBindings. This method exists
        // to override the method of the same name on the parent RoleBinding
        // object.
        WithRole(name):: error 'not implemented for kind %s' % self.kind,
    },

    Role:: $.Object.WithKind('Role') {
        WithRule(group=null, names=null, resources=null, urls=null, verbs=null):: self {
            rules+: [{
                apiGroups: if group != null then [group],
                resourceNames: names,
                resources: resources,
                nonResourceURLs: urls,
                verbs: verbs,
            }],
        },
    },

    RoleBinding:: $.Object.WithKind('RoleBinding') {
        WithClusterRole(name):: self {
            roleRef: {
                apiGroup: $.Group,
                kind: $.ClusterRole.kind,
                name: name,
            },
        },

        WithGroup(name):: self.WithSubject('Group', name),

        WithRole(name):: self {
            roleRef: {
                apiGroup: $.Group,
                kind: $.Role.kind,
                name: name,
            },
        },

        WithServiceAccount(name, namespace):: (
            self.WithSubject('ServiceAccount', name, namespace)
        ),

        WithSubject(kind, name, namespace=null):: self {
            subjects+: [{
                kind: kind,
                name: name,
                namespace: namespace,
            }],
        },

        WithUser(name):: self.WithSubject('User', name),
    },

    Verbs:: {
        // https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb
        All:: '*',
        Bind:: 'bind',
        Create:: 'create',
        Delete:: 'delete',
        DeleteCollection:: 'deletecollection',
        Escalate:: 'escalate',
        Get:: 'get',
        Impersonate:: 'impersonate',
        List:: 'list',
        Patch:: 'patch',
        Update:: 'update',
        Use:: 'use',
        Watch:: 'watch',
    },
}
