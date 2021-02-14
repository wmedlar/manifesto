local meta = import 'meta.libsonnet';

local group = 'apiextensions.k8s.io';
local version = 'v1';

local object(kind, name) =
    meta.Object(group, version, kind, null, null);

{
    Group:: group,
    Version:: version,

    CustomResourceDefinition(name):: object('CustomResourceDefinition', name) {
        WithGroup(group)::
            self + {spec+: {group: group}},

        WithNames(kind, abbrev)::
            self + {spec+: {names+: {

            }}},
    },
}
