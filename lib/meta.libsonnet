local core = import 'core.libsonnet';

{
    Group:: 'meta',
    Version:: 'v1',
    Object:: {
        // WithAPIVersion sets the apiVersion field of this object and provides
        // the APIGroup and APIVersion accessor methods.
        WithAPIVersion(group, version):: self {
            apiVersion: (
                if group == core.Group
                then version
                else group + '/' + version
            ),

            APIGroup():: group,
            APIVersion():: version,
        },

        // WithKind sets the kind field of this object.
        WithKind(kind):: self {kind: kind},

        // WithAnnotation sets the metadata.annotations field of this object.
        // This can be called multiple times to add additional annotations.
        WithAnnotation(key, value):: self {
            metadata+: {
                annotations+: {[key]: value},
            },
        },

        // WithLabel sets the metadata.labels field of this object.
        // This can be called multiple times to add additional labels.
        WithLabel(key, value):: self {
            metadata+: {
                labels+: {[key]: value},
            },
        },

        // WithName sets the metadata.name or metadata.generateName field of
        // this object, depending on the value of the generate argument, and
        // provides the Name accessor method.
        WithName(name, generate=false):: self {
            metadata+: (
                if generate
                then {generateName: name}
                else {name: name}
            ),

            Name():: name,
        },

        // WithNamespace sets the metadata.namespace field of this object and
        // provides the Namespace accessor method.
        WithNamespace(namespace):: self {
            metadata+: {
                namespace: namespace,
            },

            Namespace():: namespace,
        },
    },
}
