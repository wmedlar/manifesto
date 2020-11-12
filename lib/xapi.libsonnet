local meta = import 'meta.libsonnet';

local group = 'apiregistration.k8s.io';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, name, namespace);

{
    Group:: group,
    Version:: version,

    APIService(group, version):: object('APIService', null, null) {
        local this = self,

        metadata: {
            name: this.spec.version + '.' + this.spec.group,
        },
        spec: {
            group: group,
            version: version,
        },

        WithInsecureTLS()::
            $.withInsecureTLS(self),
        WithPriority(priority)::
            $.withPriority(self, priority),
        WithService(service)::
            $.withService(self, service),
    },

    withInsecureTLS(apiservice):: apiservice {
        spec+: {
            insecureSkipTLSVerify: true,
        },
    },

    withPriority(apiservice, priority):: apiservice {
        spec+: {
            groupPriorityMinimum: priority,
            versionPriority: priority,
        },
    },

    withService(apiservice, service):: apiservice {
        spec+: {
            service: {
                namespace: service.metadata.namespace,
                name: service.metadata.name,
            },
        },
    },
}
