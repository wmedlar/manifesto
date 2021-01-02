local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

local group = 'admissionregistration.k8s.io';
local version = 'v1';

local object(kind, name) =
    meta.Object(group, version, kind, null, name);

{
    local sharedWebhookConfiguration(kind, name) = object(kind, name) {
        internal+:: {webhook+: {name: name}},
        webhooks: [self.internal.webhook],

        WithSpec(spec)::
            self + {internal+:: {webhook+: spec}},

        WithNoSideEffects()::
            self.WithSpec({sideEffects: 'None'}),

        WithNoSideEffectsOnDryRun()::
            self.WithSpec({sideEffects: 'NoneOnDryRun'}),

        WithNamespaceSelector(key, operator, values)::
            self.WithSpec({
                namespaceSelector+: {
                    matchExpressions+: [{
                        key: key,
                        operator: operator,
                        values: values,
                    }],
                },
            }),

        WithObjectSelector(key, operator, values)::
            self.WithSpec({
                objectSelector+: {
                    matchExpressions+: [{
                        key: key,
                        operator: operator,
                        values: values,
                    }],
                },
            }),

        WithRule(groups, versions, resources, operations)::
            self.WithSpec({
                rules+: [{
                    apiGroups: groups,
                    apiVersions: versions,
                    resources: resources,
                    operations: operations,
                }],
            }),

        WithService(service, path)::
            self.WithSpec({
                clientConfig+: {
                    service+: {
                        namespace: service.metadata.namespace,
                        name: service.metadata.name,
                        path: path,
                    },
                },
            }),

        WithVersions(versions)::
            self.WithSpec({admissionReviewVersions+: versions}),
    },

    MutatingWebhookConfiguration(name)::
        sharedWebhookConfiguration('MutatingWebhookConfiguration', name),

    ValidatingWebhookConfiguration(name)::
        sharedWebhookConfiguration('ValidatingWebhookConfiguration', name),
}
