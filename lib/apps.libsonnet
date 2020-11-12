local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';
local util = import 'util.libsonnet';

local group = 'apps';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    DaemonSet(namespace, name):: object('DaemonSet', namespace, name) {
        WithContainer(container)::
            $.withContainer(self, container),
        WithEmptyVolume(name)::
            $.withEmptyVolume(self),
        WithSelector(labels)::
            $.withSelector(self, labels),
        WithServiceAccount(serviceAccount)::
            $.withServiceAccount(self, serviceAccount),
        WithStrategy(strategy)::
            $.withUpdateStrategy(self, strategy),
        WithSysctl(sysctl, value)::
            $.withSysctl(self, sysctl, value),
    },

    Deployment(namespace, name):: object('Deployment', namespace, name) {
        WithContainer(container)::
            $.withContainer(self, container),
        WithEmptyVolume(name)::
            $.withEmptyVolume(self, name),
        WithReplicas(replicas)::
            $.withReplicas(self, replicas),
        WithSelector(labels)::
            $.withSelector(self, labels),
        WithServiceAccount(serviceAccount)::
            $.withServiceAccount(self, serviceAccount),
        WithStrategy(strategy)::
            $.withStrategy(self, strategy),
        WithSysctl(sysctl, value)::
            $.withSysctl(self, sysctl, value),
    },

    withContainer(controller, container):: controller {
        spec+: {
            template+: {
                spec+: {
                    containers+: [container],
                },
            },
        },
    },

    withEmptyVolume(controller, name):: controller {
        spec+: {
            template+: {
                spec+: {
                    volumes+: [{
                        name: name,
                        emptyDir: {},
                    }],
                },
            },
        },
    },

    withReplicas(controller, replicas):: controller {
        spec+: {
            replicas: replicas,
        },
    },

    withSelector(controller, labels):: controller {
        local this = self,

        spec+: {
            selector: {
                matchLabels: labels,
            },
            template+: {
                metadata+: {
                    labels: this.spec.selector.matchLabels,
                },
            },
        },
    },

    withServiceAccount(controller, serviceAccount):: controller {
        spec+: {
            template+: {
                spec+: {
                    serviceAccountName: serviceAccount.metadata.name,
                },
            },
        },
    },

    withStrategy(controller, strategy):: controller {
        spec+: {
            strategy:
                if std.isString(strategy)
                then {type: strategy}
                else strategy,
        },
    },

    withUpdateStrategy(controller, strategy):: controller {
        spec+: {
            updateStrategy:
                if std.isString(strategy)
                then {type: strategy}
                else strategy,
        },
    },

    withSysctl(controller, sysctl, value):: controller {
        spec+: {
            template+: {
                spec+: {
                    securityContext+: {
                        sysctls+: [{
                            name: sysctl,
                            value: std.toString(value),
                        }],
                    },
                },
            },
        },
    },
}
