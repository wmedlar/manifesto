local meta = import 'meta.libsonnet';

local group = 'apiregistration.k8s.io';
local version = 'v1';

local object(kind, name) =
    meta.Object(group, version, kind, null, name);

{
    Group:: group,
    Version:: version,

    APIService(group, version):: object('APIService', version + '.' + group) {
        spec+: {
            group: group,
            version: version,
        },

        WithInsecureTLS()::
            self + {spec+: {insecureSkipTLSVerify: true}},

        WithPriority(priority)::
            self + {spec+: {
                groupPriorityMinimum: priority,
                versionPriority: priority,
            }},

        WithService(service)::
            self + {spec+: {
                service: {
                    namespace: service.metadata.namespace,
                    name: service.metadata.name,
                },
            }},
    },
}
