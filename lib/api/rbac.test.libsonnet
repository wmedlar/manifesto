local test = import 'external/com_github_yugui_jsonnetunit/jsonnetunit/test.libsonnet';
local rbac = import 'rbac.libsonnet';

test.suite({
    testBaseObject: {
        actual: rbac.Object('kind', 'name', {test: true}),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'kind',
            metadata: {name: 'name'},
            test: true,
        },
    },

    testClusterRole: {
        actual: rbac.ClusterRole('name'),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
        },
    },

    testClusterRoleWithAggregationRule: {
        actual: (
            rbac.ClusterRole('name')
            .WithAggregationRule({'aggregate-to-clusterrole': 'true'})
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
            aggregationRule: {
                clusterRoleSelectors: [{
                    matchLabels: {'aggregate-to-clusterrole': 'true'},
                }],
            },
        },
    },

    testClusterRoleWithAggregationRuleAppends: {
        actual: (
            rbac.ClusterRole('name')
            .WithAggregationRule({'aggregate-to-clusterrole': 'true'})
            .WithAggregationRule({'aggregate-to-other': 'false'})
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
            aggregationRule: {
                clusterRoleSelectors: [{
                    matchLabels: {'aggregate-to-clusterrole': 'true'},
                }, {
                    matchLabels: {'aggregate-to-other': 'false'},
                }],
            },
        },
    },

    testClusterRoleWithRule: {
        actual: (
            rbac.ClusterRole('name')
            .WithRule(['group'], ['resource1', 'resource2'], ['get', 'list', 'watch'])
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
            rules: [{
                apiGroups: ['group'],
                resources: ['resource1', 'resource2'],
                resourceNames: null,
                verbs: ['get', 'list', 'watch'],
            }],
        },
    },

    testClusterRoleWithRuleResourceNames: {
        actual: (
            rbac.ClusterRole('name')
            .WithRule(['group'], ['resource1', 'resource2'], ['name'], ['get', 'list', 'watch'])
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
            rules: [{
                apiGroups: ['group'],
                resources: ['resource1', 'resource2'],
                resourceNames: ['name'],
                verbs: ['get', 'list', 'watch'],
            }],
        },
    },

    testClusterRoleWithRuleAppends: {
        actual: (
            rbac.ClusterRole('name')
            .WithRule(['group'], ['resource1', 'resource2'], ['get', 'list', 'watch'])
            .WithRule(['anothergroup'], ['resource3'], ['create', 'update', 'patch'])
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: {name: 'name'},
            rules: [{
                apiGroups: ['group'],
                resources: ['resource1', 'resource2'],
                resourceNames: null,
                verbs: ['get', 'list', 'watch'],
            }, {
                apiGroups: ['anothergroup'],
                resources: ['resource3'],
                resourceNames: null,
                verbs: ['create', 'update', 'patch'],
            }],
        },
    },

    testClusterRoleBinding: {
        actual: rbac.ClusterRoleBinding('name'),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRoleBinding',
            metadata: {name: 'name'},
        },
    },

    testClusterRoleBindingWithRole: {
        actual: (
            rbac.ClusterRoleBinding('name')
            .WithRole(rbac.Object('role', 'rolename'))
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRoleBinding',
            metadata: {name: 'name'},
            roleRef: {
                apiGroup: 'rbac.authorization.k8s.io',
                kind: 'role',
                name: 'rolename',
            },
        },
    },

    testClusterRoleBindingWithRoleKeywordArguments: {
        actual: (
            rbac.ClusterRoleBinding('name')
            .WithRole(group='rolegroup', kind='role', name='rolename')
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRoleBinding',
            metadata: {name: 'name'},
            roleRef: {
                apiGroup: 'rolegroup',
                kind: 'role',
                name: 'rolename',
            },
        },
    },

    testClusterRoleBindingWithRoleOverwrites: {
        actual: (
            rbac.ClusterRoleBinding('name')
            .WithRole(rbac.Object('role', 'rolename'))
            .WithRole(rbac.Object('otherrole', 'othername'))
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRoleBinding',
            metadata: {name: 'name'},
            roleRef: {
                apiGroup: 'rbac.authorization.k8s.io',
                kind: 'otherrole',
                name: 'othername',
            },
        },
    },

    testClusterRoleBindingWithSubject: {
        actual: (
            rbac.ClusterRoleBinding('name')
            .WithSubject(rbac.Object('role', 'rolename'))
        ),
        expect: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRoleBinding',
            metadata: {name: 'name'},
            roleRef: {
                apiGroup: 'rbac.authorization.k8s.io',
                kind: 'role',
                name: 'rolename',
            },
        },
    },
})

{}
