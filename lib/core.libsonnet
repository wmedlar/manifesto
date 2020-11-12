local meta = import 'meta.libsonnet';
local util = import 'util.libsonnet';

local group = '';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    Container(name):: object('Container', null, name) {
        // Containers don't actually include GVK or metadata,
        // so we'll shadow those fields to avoid printing.
        apiVersion:: super.apiVersion,
        kind:: super.kind,
        metadata:: super.metadata,

        name: self.metadata.name,

        WithArg(arg)::
            $.containerWithArg(self, arg),
        WithArgs(args)::
            $.containerWithArgs(self, args),
        WithCapability(capability)::
            $.containerWithCapability(self, capability),
        WithEnv(name, value)::
            $.containerWithEnv(self, name, value),
        WithEnvFromField(name, field)::
            $.containerWithEnvFromField(self, name, field),
        WithImage(image, version=null)::
            $.containerWithImage(self, image, version),
        WithPort(name, port, protocol=null)::
            $.containerWithPort(self, name, port, protocol),
        WithReadOnlyFilesystem()::
            $.containerWithReadOnlyFilesystem(self),
        WithUser(uid)::
            $.containerWithUser(self, uid),
        WithVolumeMount(name, path)::
            $.containerWithVolumeMount(self, name, path),
    },

    containerWithArg(container, arg):: container {
        args+: [arg],
    },

    containerWithArgs(container, args):: container {
        args: args,
    },

    containerWithCapability(container, capability):: container {
        securityContext+: {
            capabilities+: {
                add+: [capability],
                drop: ['all'],
            },
        },
    },

    containerWithEnv(container, name, value):: container {
        env+: [{
            name: name,
            value: value,
        }],
    },

    containerWithEnvFromField(container, name, field):: container {
        env+: [{
            name: name,
            valueFrom: {
                fieldRef: {
                    fieldPath: field,
                },
            },
        }],
    },

    containerWithImage(container, image, version=null):: container {
        image:
            if version == null then image
            else '%s:%s' % [image, version],
    },

    containerWithPort(container, name, port, protocol=null):: container {
        ports+: [{
            name: name,
            containerPort: port,
            [if protocol != null then 'protocol']: protocol,
        }],
    },

    containerWithReadOnlyFilesystem(container):: container {
        securityContext+: {
            readOnlyRootFilesystem: true,
        },
    },

    containerWithUser(container, uid):: container {
        securityContext+: {
            runAsNonRoot: uid > 0,
            runAsUser: uid,
        },
    },

    containerWithVolumeMount(container, name, path):: container {
        volumeMounts+: [{
            name: name,
            mountPath: path,
        }],
    },

    List(items=[]):: object('List', null, null) {
        items: items,

        WithItem(item)::
            $.listWithItem(self, item),
        WithItems(items)::
            $.listWithItems(self, items),
    },

    listWithItem(list, item):: list {
        items+: [item],
    },

    listWithItems(list, items):: list {
        items: items,
    },

    Service(namespace, name):: object('Service', namespace, name) {
        WithPort(name, port, protocol=null)::
            $.serviceWithPort(self, name, port, protocol),
        WithSelector(labels)::
            $.serviceWithSelector(self, labels),
    },

    serviceWithPort(service, name, port, target=null, protocol=null):: service {
        spec+: {
            ports+: [{
                name: name,
                port: port,
                [if target != null then 'targetPort']: target,
                [if protocol != null then 'protocol']: protocol,
            }],
        },
    },

    serviceWithSelector(service, labels):: service {
        spec+: {
            selector: labels,
        },
    },

    ServiceAccount(namespace, name):: object('ServiceAccount', namespace, name),
}
