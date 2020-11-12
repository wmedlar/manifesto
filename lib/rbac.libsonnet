local meta = import 'meta.libsonnet';
local util = import 'util.libsonnet';

local group = 'rbac.authorization.k8s.io';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    ClusterRole(name):: object('ClusterRole', null, name) {
        WithAggregationSelector(labels)::
            $.roleWithAggregationSelector(self, labels),
        WithRule(groups, resources, verbs)::
            $.roleWithRule(self, groups, resources, verbs),
    },

    Role(namespace, name):: object('Role', namespace, name) {
        WithRule(groups, resources, verbs)::
            $.roleWithRule(self, groups, resources, verbs),
    },

    roleWithAggregationSelector(role, labels):: role {
        aggregationRule+: {
            clusterRoleSelectors+: [{
                matchLabels: labels,
            }],
        },
    },

    roleWithRule(role, groups, resources, verbs):: role {
        rules+: [{
            apiGroups: groups,
            resources: resources,
            verbs: verbs,
        }],
    },

    ClusterRoleBinding(name=null):: object('ClusterRoleBinding', null, name) {
        WithRole(role)::
            $.bindingWithRole(self, role),
        WithSubject(subject)::
            $.bindingWithSubject(self, subject),
    },

    RoleBinding(namespace, name=null):: object('RoleBinding', namespace, name) {
        WithRole(role)::
            $.bindingWithRole(self, role),
        WithSubject(subject)::
            $.bindingWithSubject(self, subject),
    },

    bindingWithRole(binding, role):: binding {
        metadata+:
            if !std.objectHas(binding.metadata, 'name')
               || binding.metadata.name == null
            then {name: role.metadata.name}
            else {},

        roleRef: {
            apiGroup: $.Group,
            kind: role.kind,
            name: role.metadata.name,
        },
    },

    bindingWithSubject(binding, subject):: binding {
        subjects+: [{
            kind: subject.kind,
            name: subject.metadata.name,
            namespace: subject.metadata.namespace,
        }],
    },
}
