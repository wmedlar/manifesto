{
    Object(group, version, kind, namespace, name):: {
        apiVersion: if group == '' then version else group + '/' + version,
        kind: kind,
        metadata+: {
            namespace: namespace,
            name: name,
        },

        WithAnnotation(annotation, value)::
            self + {metadata+: {annotations+: {[annotation]: value}}},
        WithAnnotations(annotations)::
            self + {metadata+: {annotations: annotations}},
        WithLabel(label, value)::
            self + {metadata+: {labels+: {[label]: value}}},
        WithLabels(labels)::
            self + {metadata+: {labels: labels}},
        WithName(name)::
            self + {metadata+: {name: name}},
        WithNamespace(namespace)::
            self + {metadata+: {namespace: namespace}},
        WithSpec(spec)::
            self + {spec+: spec},
    },
}
