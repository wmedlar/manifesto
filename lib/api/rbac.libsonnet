local meta = import 'meta.libsonnet';

local group = 'rbac.authorization.k8s.io';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    role(kind, namespace, name):: object(kind, namespace, name) {
        WithRule(groups, resources, maybeNamesOrVerbs, maybeVerbs=null)::
            local names = if maybeVerbs == null then null else maybeNamesOrVerbs;
            local verbs = if maybeVerbs == null then maybeNamesOrVerbs else maybeVerbs;

            self + {rules+: [{
                apiGroups: groups,
                resources: resources,
                [if names != null then 'resourceNames']: names,
                verbs: verbs,
            }]},
    },

    ClusterRole(name):: $.role('ClusterRole', null, name) {
        WithAggregationSelector(labels)::
            self + {aggregationRule+: {
                clusterRoleSelectors+: [{matchLabels: labels}],
            }},
    },

    Role(namespace, name):: $.role('Role', namespace, name),

    rolebinding(kind, namespace, name):: object(kind, namespace, name) {
        WithRole(role)::
            local maybeBindingName =
                if self.metadata.name == null
                then {metadata+: {name: role.metadata.name}}
                else {};

            self + maybeBindingName + {roleRef: {
                apiGroup: $.Group,
                kind: role.kind,
                name: role.metadata.name,
            }},

        WithSubject(subject)::
            self + {subjects+: [{
                kind: subject.kind,
                name: subject.metadata.name,
                namespace: subject.metadata.namespace,
            }]},
    },

    ClusterRoleBinding(name=null):: $.rolebinding('ClusterRoleBinding', null, name),

    RoleBinding(namespace, name=null):: $.rolebinding('RoleBinding', namespace, name),
}
