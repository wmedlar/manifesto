local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

local group = 'admissionregistration.k8s.io';
local version = 'v1';

local object(kind, name) =
    meta.Object(group, version, kind, null, name);

{
    Group:: group,
    Version:: version,

    webhook(kind, name):: object(kind, null) {
        // Webhooks don't actually include GVK or metadata,
        // so we'll shadow those fields to avoid printing.
        apiVersion:: super.apiVersion,
        kind:: super.kind,
        metadata:: super.metadata,
        name: name,

        WithAdmissionReviewVersions(versions)::
            self + {admissionReviewVersions: versions},

        WithNamespaceSelector(key, operator, values)::
            self + {namespaceSelector+: {matchExpressions+: [{
                key: key,
                operator: operator,
                values: values,
            }]}},

        WithNoSideEffects()::
            self + {sideEffects: 'None'},

        WithNoSideEffectsOnDryRun()::
            self + {sideEffects: 'NoneOnDryRun'},

        WithRule(groups, versions, resources, operations)::
            self + {rules+: [{
                apiGroups: groups,
                apiVersions: versions,
                resources: resources,
                operations: operations,
            }]},

        WithService(service, path)::
            self + {clientConfig+: {service: {
                namespace: service.metadata.namespace,
                name: service.metadata.name,
                path: path,
            }}},
    },

    MutatingWebhook(name):: $.webhook('MutatingWebhook', name),

    MutatingWebhookConfiguration(name):: object('MutatingWebhookConfiguration', name) {
        WithWebhook(name, func)::
            local webhook = func($.MutatingWebhook(name));
            self + {webhooks+: [webhook]},
    },

    ValidatingWebhook(name):: $.webhook('ValidatingWebhook', name),

    ValidatingWebhookConfiguration(name):: object('ValidatingWebhookConfiguration', name) {
        WithWebhook(name, func)::
            local webhook = func($.ValidatingWebhook(name));
            self + {webhooks+: [webhook]},
    },
}
