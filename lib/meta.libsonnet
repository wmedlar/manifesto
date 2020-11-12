local util = import 'util.libsonnet';

{
    Object(group, version, kind, namespace, name):: {
        apiVersion: if group == '' then version else group + '/' + version,
        kind: kind,
        metadata: std.prune({
            namespace: namespace,
            name: name,
        }),

        WithAnnotation(key, value)::
            $.withAnnotation(self, key, value),
        WithAnnotations(annotations)::
            $.withAnnotations(self, annotations),
        WithLabel(key, value)::
            $.withLabel(self, key, value),
        WithLabels(labels)::
            $.withLabels(self, labels),
        WithName(name)::
            $.withName(self, name),
        WithNamespace(namespace)::
            $.withNamespace(self, namespace),
    },

    withAnnotation(object, key, value):: object {
        metadata+: {
            annotations+: {[key]: value},
        },
    },

    withAnnotations(object, annotations):: object {
        metadata+: {
            annotations: annotations,
        },
    },

    withLabel(object, key, value):: object {
        metadata+: {
            labels+: {[key]: value},
        },
    },

    withLabels(object, labels):: object {
        metadata+: {
            labels: labels,
        },
    },

    withName(object, name):: object {
        metadata+: {
            name: name,
        },
    },

    withNamespace(object, namespace):: object {
        metadata+: {
            namespace: namespace,
        },
    },
}
