local meta = import 'meta.libsonnet';

{
    Group:: 'core',
    Version:: 'v1',
    Object:: meta.Object.WithAPIVersion($.Group, $.Version),

    ConfigMap:: $.Object.WithKind('ConfigMap') {
        // WithBinaryData sets the binaryData field of this object. The value
        // should be a base64-encoded string. This can be called multiple times
        // to add additional data.
        WithBinaryData(key, value):: self {
            binaryData+: {[key]: value},
        },

        // WithData sets the data field of this object. This can be called
        // multiple times to add additional data.
        WithData(key, value):: self {
            data+: {[key]: value},
        },

        // WithImmutability sets the immutable field of this object. If no
        // argument is passed, this field will be set to true.
        WithImmutability(value=true):: self {immutable: value},
    },

    Container:: $.Object.WithKind('Container').WithoutTypeMeta() {
        WithArg():: error 'not implemented',
        WithArgs():: error 'not implemented',
        WithCommand():: error 'not implemented',
        WithEnv():: error 'not implemented',
        WithEnvFrom():: error 'not implemented',
        WithImage():: error 'not implemented',
        WithImagePullPolicy():: error 'not implemented',
        WithLifecycle():: error 'not implemented',
        WithLivenessProbe():: error 'not implemented',

        // WithName sets the name field of this object.
        WithName(name):: self {name: name},

        WithPort():: error 'not implemented',
        WithReadinessProbe():: error 'not implemented',
        WithResources():: error 'not implemented',
        WithSecurityContext():: error 'not implemented',
        WithStartupProbe():: error 'not implemented',
        WithStdin(value=true):: error 'not implemented',
        WithStdinOnce(value=true):: error 'not implemented',
        WithTerminationMessagePath(path):: error 'not implemented',
        WithTerminationMessagePolicy(policy):: error 'not implemented',
        WithTTY(value=true):: error 'not implemented',
        WithVolumeDevice():: error 'not implemented',
        WithVolumeMount():: error 'not implemented',
        WithWorkingDirectory(path):: error 'not implemented',
    },

    Endpoints:: $.Object.WithKind('Endpoints') {},

    Event:: $.Object.WithKind('Event') {},

    LimitRange:: $.Object.WithKind('LimitRange') {},

    List:: $.Object.WithKind('List') {
        // Map calls a function on each object in the items field and replaces
        // and replaces it with the return value. This method can be used to
        // apply common configuration to multiple objects at once.
        Map(func):: self {
            items: std.map(func, super.items),
        },

        // WithItem sets the items field of this object. This can be called
        // multiple times to add additional items.
        WithItem(item):: self {items+: [item]},

        // WithItems sets the items field of this object.
        WithItems(items):: self {items: items},
    },

    Namespace:: $.Object.WithKind('Namespace') {
        // WithFinalizer sets the spec.finalizers field of this object. This can
        // be called multiple times to add additional finalizers.
        WithFinalizer(finalizer):: self {
            spec+: {finalizers+: [finalizer]},
        },
    },

    Node:: $.Object.WithKind('Node') {},

    PersistentVolume:: $.Object.WithKind('PersistentVolume') {},

    PersistentVolumeClaim:: $.Object.WithKind('PersistentVolumeClaim') {},

    Pod:: $.Object.WithKind('Pod') {
        DNSPolicy:: {
            // https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy
            ClusterFirst:: 'ClusterFirst',
            ClusterFirstWithHostNet:: 'ClusterFirstWithHostNet',
            Default:: 'Default',
            None:: 'None',
        },

        // WithActiveDeadlineSeconds sets the spec.activeDeadlineSeconds field
        // of this object.
        WithActiveDeadlineSeconds(value):: self {
            spec+: {activeDeadlineSeconds: value},
        },


        WithAffinity():: error 'not implemented',

        // WithAutomountServiceAccountToken sets the
        // spec.automountServiceAccountToken field of this object. If no
        // argument is passed, the field will be set to true.
        WithAutomountServiceAccountToken(value=true):: self {
            spec+: {automountServiceAccountToken: value},
        },

        // WithContainer sets the spec.containers field of this object. If a
        // function is passed as the argument, it is called with an empty
        // core.Container and the field is set to its return value, otherwise
        // the argument is used directly.
        WithContainer(value):: self {
            spec+: {
                containers+: [
                    if std.isFunction(value)
                    then value($.Container)
                    else value,
                ],
            },
        },

        WithDNSConfig():: error 'not implemented',
        WithDNSPolicy():: error 'not implemented',

        // WithEnableServiceLinks sets the spec.enableServiceLinks field of this
        // object. If no argument is passed, the field will be set to true.
        WithEnableServiceLinks(value=true):: self {
            spec+: {enableServiceLinks: value},
        },

        // WithHostAlias sets the spec.hostAliases field of this object. This
        // can be called multiple times to add additional aliases.
        WithHostAlias(ip, hostnames):: self {
            spec+: {
                hostAliases+: [{ip: ip, hostnames: hostnames}],
            },
        },

        WithHostIPC():: error 'not implemented',
        WithHostNetwork():: error 'not implemented',
        WithHostPID():: error 'not implemented',
        WithHostname():: error 'not implemented',
        WithImagePullSecret():: error 'not implemented',

        // WithInitContainer sets the spec.initContainers field of this object.
        // If a function is passed as the argument, it is called with an empty
        // core.Container and the field is set to its return value, otherwise
        // the argument is used directly.
        WithInitContainer(value):: self {
            spec+: {
                initContainers+: [
                    if std.isFunction(value)
                    then value($.Container)
                    else value,
                ],
            },
        },

        WithNodeName():: error 'not implemented',
        WithNodeSelector():: error 'not implemented',
        WithOverhead():: error 'not implemented',
        WithPreemptionPolicy():: error 'not implemented',
        WithPriority():: error 'not implemented',
        WithPriorityClassName():: error 'not implemented',
        WithReadinessGate():: error 'not implemented',
        WithRestartPolicy():: error 'not implemented',
        WithRuntimeClassName():: error 'not implemented',
        WithSchedulerName():: error 'not implemented',
        WithSecurityContext():: error 'not implemented',
        WithServiceAccountName():: error 'not implemented',
        WithSetHostnameAsFQDN(value=true):: error 'not implemented',
        WithShareProcessNamespace(value=true):: error 'not implemented',
        WithSubdomain():: error 'not implemented',
        WithTerminationGracePeriodSeconds():: error 'not implemented',
        WithToleration():: error 'not implemented',
        WithTopologySpreadConstraint():: error 'not implemented',
        WithVolume():: error 'not implemented',
    },

    PodTemplate:: $.Pod.WithoutTypeMeta() {},

    ResourceQuota:: $.Object.WithKind('ResourceQuota') {},

    Secret:: $.Object.WithKind('Secret') {
        Types:: {
            // https://kubernetes.io/docs/concepts/configuration/secret/#secret-types
            Opaque:: 'Opaque',
            BasicAuth:: 'kubernetes.io/basic-auth',
            BootstrapToken:: 'bootstrap.kubernetes.io/token',
            DockerConfig:: 'kubernetes.io/dockercfg',
            DockerConfigJson:: 'kubernetes.io/dockerconfigjson',
            ServiceAccountToken:: 'kubernetes.io/service-account-token',
            SSHAuth:: 'kubernetes.io/ssh-auth',
            TLS:: 'kubernetes.io/tls',
        },

        // WithData sets the data field of this object. The value should be a
        // base64-encoded string. This can be called multiple times to add
        // additional data.
        WithData(key, value):: self {
            data+: {[key]: value},
        },

        // WithImmutability sets the immutable field of this object. If no
        // argument is passed, this field will be set to true.
        WithImmutability(value=true):: self {immutable: value},

        // WithStringData sets the stringData field of this object. This can be
        // called multiple times to add additional data.
        WithStringData(key, value):: self {
            stringData+: {[key]: value},
        },

        // WithType sets the type field of this object. Constants for built-in
        // types can be found in the hidden Type field.
        WithType(type):: self {type: type},
    },

    Service:: $.Object.WithKind('Service') {
        TrafficPolicy:: {
            Cluster:: 'Cluster',
            Local:: 'Local',
        },

        Types:: {
            // https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
            ClusterIP:: 'ClusterIP',
            ExternalName:: 'ExternalName',
            LoadBalancer:: 'LoadBalancer',
            NodePort:: 'NodePort',
        },

        WithAllocateLoadBalancerNodePorts(value=true):: error 'not implemented',
        WithClusterIP(ip):: error 'not implemented',
        WithExternalIP(ip):: error 'not implemented',
        WithExternalName(name):: error 'not implemented',

        // WithExternalTrafficPolicy sets the spec.externalTrafficPolicy field
        // of this object. Constants for built-in polices can be found in the
        // hidden TrafficPolicy field.
        WithExternalTrafficPolicy(policy):: self {
            spec+: {externalTrafficPolicy: policy},
        },

        WithHealthCheckNodePort(port):: error 'not implemented',
        WithIPFamily(family):: error 'not implemented',
        WithIPFamilyPolicy(policy):: error 'not implemented',
        WithLoadBalancerIP(ip):: error 'not implemented',
        WithLoadBalancerSourceRange(range):: error 'not implemented',

        WithPort(name, port, protocol=null):: error 'not implemented',

        WithPublishNotReadyAddresses(value=true):: error 'not implemented',

        // WithSelector sets the spec.selector field of this object.
        WithSelector(labels):: self {
            spec+: {selector: labels},
        },

        WithSessionAffinity(affinity):: error 'not implemented',
        WithSessionAffinityConfig(config):: error 'not implemented',
        WithTopologyKey(key):: error 'not implemented',

        // WithType sets the type field of this object. Constants for built-in
        // types can be found in the hidden Types field.
        WithType(type):: self {
            spec+: {type: type},
        },
    },

    ServiceAccount:: $.Object.WithKind('ServiceAccount') {
        WithAutomountServiceAccountToken(value=true):: error 'not implemented',
        WithImagePullSecret(name):: error 'not implemented',
        WithSecret():: error 'not implemented',
    },
}
