local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

local group = 'admissionregistration.k8s.io';
local version = 'v1';

local object(kind, name) =
    meta.Object(group, version, kind, null, name);

{
    Group:: group,
    Version:: version,

    WebhookConfiguration(kind, name):: object(kind, name) {
        hello: world,
    },

    MutatingWebhookConfiguration(name):: WebhookConfiguration('MutatingWebhookConfiguration', name),

    ValidatingWebhookConfiguration(name):: WebhookConfiguration('ValidatingWebhookConfiguration', name),
}
