local meta = import 'meta.libsonnet';

local group = '';
local version = 'v1';

local object(kind, namespace, name) =
    meta.Object(group, version, kind, namespace, name);

{
    Group:: group,
    Version:: version,

    ConfigMap(namespace, name):: object('ConfigMap', namespace, name) {
        WithData(key, value)::
            self + {data+: {[key]: value}},
    },

    Container(name):: object('Container', null, null) {
        // Containers don't actually include GVK or metadata,
        // so we'll shadow those fields to avoid printing.
        apiVersion:: super.apiVersion,
        kind:: super.kind,
        metadata:: super.metadata,
        name: name,

        WithArg(arg)::
            self + {args+: [arg]},
        WithArgs(args)::
            self + {args: args},

        WithCapabilities(add=null, drop=null)::
            self + {securityContext+: {
                capabilities+: {add: add, drop: drop},
            }},

        WithEnv(name, value)::
            self + {env+: [{name: name, value: value}]},

        WithEnvFromField(name, field)::
            self + {env+: [{
                name: name,
                valueFrom: {fieldRef: {fieldPath: field}},
            }]},

        WithGroupID(gid)::
            self + {securityContext+: {runAsGroup: gid}},

        WithImage(base, version=null)::
            self + {image: if version == null then base else base + ':' + version},

        WithLivenessProbe(probe)::
            self + {livenessProbe: probe},

        WithPort(name, port, protocol=null)::
            self + {ports+: [{
                name: name,
                containerPort: port,
                protocol: protocol,
            }]},

        WithReadinessProbe(probe)::
            self + {readinessProbe: probe},

        WithReadOnlyFilesystem()::
            self + {securityContext+: {readOnlyRootFilesystem: true}},

        WithResourceLimits(cpu=null, memory=null)::
            self + {resources+: {limits: {cpu: cpu, memory: memory}}},

        WithResourceRequests(cpu=null, memory=null)::
            self + {resources+: {requests: {cpu: cpu, memory: memory}}},

        WithUserID(uid)::
            self + {securityContext+: {
                runAsNonRoot: uid > 0,
                runAsUser: uid,
            }},

        WithVolumeMount(name, path)::
            self + {volumeMounts+: [{name: name, mountPath: path}]},
    },

    List(items=[]):: object('List', null, null) {items: items},

    Namespace(name):: object('Namespace', null, name),

    Probe():: object('Probe', null, null) {
        apiVersion:: super.apiVersion,
        kind:: super.kind,
        metadata:: super.metadata,

        WithHTTPGet(path, port, headers=null)::
            self + $.probeWithHTTPGet(path, port, 'HTTP', headers),

        WithHTTPSGet(path, port, headers=null)::
            self + $.probeWithHTTPGet(path, port, 'HTTPS', headers),

        WithDelay(seconds)::
            self + {initialDelaySeconds: seconds},
        WithFailureThreshold(count)::
            self + {failureThreshold: count},
        WithFrequency(seconds)::
            self + {periodSeconds: seconds},
        WithSuccessThreshold(count)::
            self + {successThreshold: count},
        WithTimeout(seconds)::
            self + {timeoutSeconds: seconds},
    },

    probeWithHTTPGet(path, port, scheme, headers=null)::
        local maybeHTTPHeaders =
            if headers != null
            then {httpHeaders: [
                {name: key, value: headers[key]}
                for key in std.objectHas(headers)
            ]}
            else {};
        {
            exec:: null,
            httpGet: maybeHTTPHeaders {
                path: path,
                port: port,
                scheme: scheme,
            },
            tcpSocket:: null,
        },

    Secret(namespace, name):: object('Secret', namespace, name),

    Service(namespace, name):: object('Service', namespace, name) {
        WithPort(name, port, target=null, protocol=null)::
            self + {spec+: {ports+: [{
                name: name,
                port: port,
                targetPort: target,
                protocol: protocol,
            }]}},

        WithSelector(labels)::
            self + {spec+: {selector: labels}},

        WithType(type)::
            self + {spec+: {type: type}},
    },

    ServiceAccount(namespace, name):: object('ServiceAccount', namespace, name),
}
