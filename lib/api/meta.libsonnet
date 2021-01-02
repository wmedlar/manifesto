local apiVersion(group, version) =
    if group == '' then version
    else group + '/' + version
;

{
    Object(group, version, kind, namespace, name):: {
        internal:: {group:: group, version:: version},

        apiVersion: apiVersion(self.internal.group, self.internal.version),
        kind: kind,
        metadata+: {
            namespace: namespace,
            name: name,
        },

        WithAnnotation(key, value)::
            self + {metadata+: {annotations+: {[key]: value}}},
        WithLabel(key, value)::
            self + {metadata+: {labels+: {[key]: value}}},
        WithName(name)::
            self + {metadata+: {name: name}},
        WithNamespace(namespace)::
            self + {metadata+: {namespace: namespace}},
        WithSpec(spec)::
            self + {spec+: spec},
    },
}
