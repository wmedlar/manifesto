local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

local group = 'apps';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    controller(kind, namespace, name):: object(kind, namespace, name) {
        WithContainer(container)::
            self + {spec+: {template+: {spec+: {
                containers+: [container],
            }}}},

        WithReplicas(count)::
            self + {spec+: {replicas: count}},

        WithSelector(labels)::
            self + {spec+: {
                selector: {matchLabels: labels},
                template+: {metadata+: {labels: labels}},
            }},

        WithServiceAccount(serviceAccount)::
            self + {spec+: {template+: {spec+: {
                serviceAccountName: serviceAccount.metadata.name,
            }}}},

        WithStrategy(strategy)::
            self + {spec+: {
                strategy+: {type: strategy},
            }},

        WithSysctl(name, value)::
            self + {spec+: {template+: {spec+: {
                securityContext+: {
                    sysctls+: [{name: name, value: std.toString(value)}],
                },
            }}}},

        WithVolume(volume)::
            self + {spec+: {template+: {spec+: {volumes+: [volume]}}}},

        WithVolumes(volumes)::
            self + {spec+: {template+: {spec+: {volumes: volumes}}}},
    },

    DaemonSet(namespace, name):: $.controller('DaemonSet', namespace, name) {
        WithStrategy(strategy)::
            self + {spec+: {
                updateStrategy+: {type: strategy},
            }},
    },

    Deployment(namespace, name):: $.controller('Deployment', namespace, name),
}
