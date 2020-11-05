local core = import 'lib/core.libsonnet';

core.List([
    {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'ClusterRole',
        metadata: {
            name: 'system:metrics-reader',
            labels: {
                'rbac.authorization.k8s.io/aggregate-to-view': 'true',
                'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
                'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
            },
        },
        rules: [{
            apiGroups: ['metrics.k8s.io'],
            resources: ['nodes', 'pods'],
            verbs: ['get', 'list', 'watch'],
        }],
    },
    {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'ClusterRoleBinding',
        metadata: {
            name: 'metrics-server:system:auth-delegator',
        },
        roleRef: {
            apiGroup: 'rbac.authorization.k8s.io',
            kind: 'ClusterRole',
            name: 'system:auth-delegator',
        },
        subjects: [{
            kind: 'ServiceAccount',
            namespace: 'kube-system',
            name: 'metrics-server',
        }],
    },
    {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'RoleBinding',
        metadata: {
            namespace: 'kube-system',
            name: 'metrics-server-auth-reader',
        },
        roleRef: {
            apiGroup: 'rbac.authorization.k8s.io',
            kind: 'Role',
            name: 'extension-apiserver-authentication-reader',
        },
        subjects: [{
            kind: 'ServiceAccount',
            namespace: 'kube-system',
            name: 'metrics-server',
        }],
    },
    {
        apiVersion: 'apiregistration.k8s.io/v1beta1',
        kind: 'APIService',
        metadata: {
            name: 'v1beta1.metrics.k8s.io',
        },
        spec: {
            group: 'metrics.k8s.io',
            groupPriorityMinimum: 100,
            insecureSkipTLSVerify: true,
            service: {
                namespace: 'kube-system',
                name: 'metrics-server',
            },
            version: 'v1beta1',
            versionPriority: 100,
        },
    },
    {
        apiVersion: 'v1',
        kind: 'ServiceAccount',
        metadata: {
            namespace: 'kube-system',
            name: 'metrics-server',
        },
    },
    {
        local deployment = self,

        apiVersion: 'apps/v1',
        kind: 'Deployment',
        metadata: {
            namespace: 'kube-system',
            name: 'metrics-server',
        },
        spec: {
            selector: {
                matchLabels: {
                    'app.kubernetes.io/name': deployment.metadata.name,
                },
            },
            template: {
                metadata: {
                    labels: deployment.spec.selector.matchLabels {
                        'app.kubernetes.io/version': 'v0.3.7',
                    },
                },
                spec: {
                    containers: [{
                        name: 'metrics-server',
                        image: 'k8s.gcr.io/metrics-server/metrics-server:v0.3.7',
                        args: [
                            '--cert-dir=/tmp',
                            '--kubelet-preferred-address-types=InternalIP',
                            '--secure-port=4443',
                        ],
                        ports: [{
                            name: 'https',
                            containerPort: 4443,
                            protocol: 'TCP',
                        }],
                        securityContext: {
                            readOnlyRootFilesystem: true,
                            runAsNonRoot: true,
                            runAsUser: 1000,
                        },
                        volumeMounts: [{
                            name: 'tmp',
                            mountPath: '/tmp',
                        }],
                    }],
                    serviceAccountName: 'metrics-server',
                    volumes: [{
                        name: 'tmp',
                        emptyDir: {},
                    }],
                },
            },
        },
    },
    {
        apiVersion: 'v1',
        kind: 'Service',
        metadata: {
            namespace: 'kube-system',
            name: 'metrics-server',
            labels: {
                'kubernetes.io/name': 'metrics-server',
                'kubernetes.io/cluster-service': 'true',
            },
        },
        spec: {
            ports: [{
                name: 'https',
                port: 443,
                targetPort: 'https',
            }],
            selector: {
                'app.kubernetes.io/name': 'metrics-server',
            },
        },
    },
    {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'ClusterRole',
        metadata: {
            name: 'system:metrics-server',
        },
        rules: [{
            apiGroups: [''],
            resources: ['configmaps', 'namespaces', 'nodes', 'nodes/stats', 'pods'],
            verbs: ['get', 'list', 'watch'],
        }],
    },
    {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'ClusterRoleBinding',
        metadata: {
            name: 'system:metrics-server',
        },
        roleRef: {
            apiGroup: 'rbac.authorization.k8s.io',
            kind: 'ClusterRole',
            name: 'system:metrics-server',
        },
        subjects: [{
            kind: 'ServiceAccount',
            namespace: 'kube-system',
            name: 'metrics-server',
        }],
    },
])
