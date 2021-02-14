local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

{
    Group:: 'apps',
    Version:: 'v1',
    Object:: meta.Object.WithAPIVersion($.Group, $.Version),

    DaemonSet:: $.ReplicaSet.WithKind('DaemonSet') {
        Strategy:: {
            OnDelete:: 'OnDelete',
            RollingUpdate:: 'RollingUpdate',
        },

        // WithReplicas is not supported for DaemonSets. This method exists to
        // override the method of the same name on the parent ReplicaSet object.
        WithReplicas(value):: error 'not implemented for kind %s' % self.kind,

        // WithStrategy sets the spec.updateStrategy field of this object.
        // Constants for built-in strategies can be found in the hidden Strategy
        // field.
        WithStrategy(type, unavailable=null):: self {
            spec+: {
                updateStrategy: {
                    rollingUpdate: (
                        if type == super.Strategy.RollingUpdate
                        then {maxUnavailable: unavailable}
                    ),
                    type: type,
                },
            },
        },
    },

    Deployment:: $.ReplicaSet.WithKind('Deployment') {
        Strategy:: {
            Recreate:: 'Recreate',
            RollingUpdate:: 'RollingUpdate',
        },

        // WithPaused sets the spec.paused field of this object. If no argument
        // is passed, this field will be set to true.
        WithPaused(value=true):: self {
            spec+: {paused: value},
        },

        // WithProgressDeadlineSeconds sets the spec.progressDeadlineSeconds
        // field of this object.
        WithProgressDeadlineSeconds(value):: self {
            spec+: {progressDeadlineSeconds: value},
        },

        // WithStrategy sets the spec.strategy field of this object. Constants
        // for built-in strategies can be found in the hidden Strategy field.
        WithStrategy(type, surge=null, unavailable=null):: self {
            spec+: {
                strategy: {
                    rollingUpdate: (
                        if type == super.Strategy.RollingUpdate
                        then {maxSurge: surge, maxUnavailable: unavailable}
                    ),
                    type: type,
                },
            },
        },
    },

    ReplicaSet:: $.Object.WithKind('ReplicaSet') {
        // ReplicaSet contains methods common to other apps/v1 controllers.

        // WithMinReadySeconds sets the spec.minReadySeconds field of this
        // object.
        WithMinReadySeconds(value):: self {
            spec+: {minReadySeconds: value},
        },

        // WithReplicas sets the spec.replicas field of this object.
        WithReplicas(value):: self {
            spec+: {replicas: value},
        },

        // WithRevisionHistoryLimit sets the spec.revisionHistoryLimit field of
        // this object.
        WithRevisionHistoryLimit(value):: self {
            spec+: {revisionHistoryLimit: value},
        },

        WithSelector(selector):: error 'not implemented',

        // WithTemplate sets the spec.template field of this object. If a
        // function is passed as the argument, it is called with an empty
        // core.PodTemplate and the field is set to its return value, otherwise
        // the argument is used directly.
        WithTemplate(value):: self {
            spec+: {
                template: (
                    if std.isFunction(value)
                    then value(core.PodTemplate)
                    else value
                ),
            },
        },
    },

    StatefulSet:: $.ReplicaSet.WithKind('StatefulSet') {
        PodManagementPolicy:: {
            OrderedReady:: 'OrderedReady',
            Parallel:: 'Parallel',
        },

        Strategy:: {
            RollingUpdate:: 'RollingUpdate',
        },

        WithPodManagementPolicy(policy):: error 'not implemented',

        // WithServiceName sets the spec.serviceName field of this object.
        WithServiceName(name):: self {
            spec+: {serviceName: name},
        },

        // WithStrategy sets the spec.updateStrategy field of this object.
        // Constants for built-in strategies can be found in the hidden Strategy
        // field.
        WithStrategy(type, partition=null):: self {
            spec+: {
                updateStrategy: {
                    rollingUpdate: (
                        if type == super.Strategy.RollingUpdate
                        then {partition: partition}
                    ),
                    type: type,
                },
            },
        },

        WithVolumeClaimTemplate():: error 'not implemented',
    },
}
