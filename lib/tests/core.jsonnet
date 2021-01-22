local test = import 'external/jsonnetunit/jsonnetunit/test.libsonnet';
local core = import 'lib/core.libsonnet';

test.suite({
    testObject: {
        actual: core.Object,
        expect: {apiVersion: 'v1'},
    },

    testConfigMap: {
        actual: core.ConfigMap,
        expect: {apiVersion: 'v1', kind: 'ConfigMap'},
    },
    testConfigMapWithBinaryData: {
        actual: core.ConfigMap.WithBinaryData('key', 'dmFsdWUK'),
        expect: {
            apiVersion: 'v1',
            kind: 'ConfigMap',
            binaryData: {key: 'dmFsdWUK'},
        },
    },
    testConfigMapWithBinaryDataMergesExisting: {
        actual: (
            core.ConfigMap
            .WithBinaryData('key', 'dmFsdWUK')
            .WithBinaryData('merged', 'dHJ1ZQo=')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'ConfigMap',
            binaryData: {key: 'dmFsdWUK', merged: 'dHJ1ZQo='},
        },
    },
    testConfigMapWithData: {
        actual: core.ConfigMap.WithData('key', 'value'),
        expect: {
            apiVersion: 'v1',
            kind: 'ConfigMap',
            data: {key: 'value'},
        },
    },
    testConfigMapWithDataMergesExisting: {
        actual: (
            core.ConfigMap
            .WithData('key', 'value')
            .WithData('merged', 'true')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'ConfigMap',
            data: {key: 'value', merged: 'true'},
        },
    },
    testConfigMapWithImmutability: {
        actual: core.ConfigMap.WithImmutability(true),
        expect: {apiVersion: 'v1', kind: 'ConfigMap', immutable: true},
    },
    testConfigMapWithImmutabilityOverwritesExisting: {
        actual: (
            core.ConfigMap
            .WithImmutability(true)
            .WithImmutability(false)
        ),
        expect: {apiVersion: 'v1', kind: 'ConfigMap', immutable: false},
    },

    testEndpoints: {
        actual: core.Endpoints,
        expect: {apiVersion: 'v1', kind: 'Endpoints'},
    },

    testEvent: {
        actual: core.Event,
        expect: {apiVersion: 'v1', kind: 'Event'},
    },

    testLimitRange: {
        actual: core.LimitRange,
        expect: {apiVersion: 'v1', kind: 'LimitRange'},
    },

    testList: {
        actual: core.List,
        expect: {apiVersion: 'v1', kind: 'List'},
    },
    testListMap: {
        actual: core.List.WithItems(['a', 'b', 'c']).Map(std.codepoint),
        expect: {apiVersion: 'v1', kind: 'List', items: [97, 98, 99]},
    },
    testListWithItems: {
        actual: core.List.WithItems(['a', 'b', 'c']),
        expect: {apiVersion: 'v1', kind: 'List', items: ['a', 'b', 'c']},
    },
    testListWithItemsOverwritesExisting: {
        actual: (
            core.List
            .WithItems(['over', 'written'])
            .WithItems(['a', 'b', 'c'])
        ),
        expect: {apiVersion: 'v1', kind: 'List', items: ['a', 'b', 'c']},
    },

    testNamespace: {
        actual: core.Namespace,
        expect: {apiVersion: 'v1', kind: 'Namespace'},
    },
    testNamespaceWithFinalizer: {
        actual: core.Namespace.WithFinalizer('test'),
        expect: {
            apiVersion: 'v1',
            kind: 'Namespace',
            spec: {finalizers: ['test']},
        },
    },
    testNamespaceWithFinalizerAppendsExisting: {
        actual: (
            core.Namespace
            .WithFinalizer('test')
            .WithFinalizer('appended')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Namespace',
            spec: {finalizers: ['test', 'appended']},
        },
    },

    testNode: {
        actual: core.Node,
        expect: {apiVersion: 'v1', kind: 'Node'},
    },

    testPersistentVolume: {
        actual: core.PersistentVolume,
        expect: {apiVersion: 'v1', kind: 'PersistentVolume'},
    },

    testPersistentVolumeClaim: {
        actual: core.PersistentVolumeClaim,
        expect: {apiVersion: 'v1', kind: 'PersistentVolumeClaim'},
    },

    testPod: {
        actual: core.Pod,
        expect: {apiVersion: 'v1', kind: 'Pod'},
    },

    testResourceQuota: {
        actual: core.ResourceQuota,
        expect: {apiVersion: 'v1', kind: 'ResourceQuota'},
    },

    testSecret: {
        actual: core.Secret,
        expect: {apiVersion: 'v1', kind: 'Secret'},
    },
    testSecretWithData: {
        actual: core.Secret.WithData('key', 'dmFsdWUK'),
        expect: {
            apiVersion: 'v1',
            kind: 'Secret',
            data: {key: 'dmFsdWUK'},
        },
    },
    testSecretWithDataMergesExisting: {
        actual: (
            core.Secret
            .WithData('key', 'dmFsdWUK')
            .WithData('merged', 'dHJ1ZQo=')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Secret',
            data: {key: 'dmFsdWUK', merged: 'dHJ1ZQo='},
        },
    },
    testSecretWithImmutability: {
        actual: core.Secret.WithImmutability(true),
        expect: {apiVersion: 'v1', kind: 'Secret', immutable: true},
    },
    testSecretWithImmutabilityOverwritesExisting: {
        actual: (
            core.Secret
            .WithImmutability(true)
            .WithImmutability(false)
        ),
        expect: {apiVersion: 'v1', kind: 'Secret', immutable: false},
    },
    testSecretWithStringData: {
        actual: core.Secret.WithStringData('key', 'value'),
        expect: {
            apiVersion: 'v1',
            kind: 'Secret',
            stringData: {key: 'value'},
        },
    },
    testSecretWithStringDataMergesExisting: {
        actual: (
            core.Secret
            .WithStringData('key', 'value')
            .WithStringData('merged', 'true')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Secret',
            stringData: {key: 'value', merged: 'true'},
        },
    },
    testSecretWithType: {
        actual: core.Secret.WithType('test'),
        expect: {apiVersion: 'v1', kind: 'Secret', type: 'test'},
    },
    testSecretWithTypeOverwritesExisting: {
        actual: (
            core.Secret
            .WithType('overwritten')
            .WithType('test')
        ),
        expect: {apiVersion: 'v1', kind: 'Secret', type: 'test'},
    },

    testService: {
        actual: core.Service,
        expect: {apiVersion: 'v1', kind: 'Service'},
    },
    testServiceWithExternalTrafficPolicy: {
        actual: core.Service.WithExternalTrafficPolicy('test'),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {externalTrafficPolicy: 'test'},
        },
    },
    testServiceWithExternalTrafficPolicyOverwritesExisting: {
        actual: (
            core.Service
            .WithExternalTrafficPolicy('overwritten')
            .WithExternalTrafficPolicy('test')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {externalTrafficPolicy: 'test'},
        },
    },
    testServiceWithSelector: {
        actual: core.Service.WithSelector({test: 'true'}),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {
                selector: {test: 'true'},
            },
        },
    },
    testServiceWithSelectorOverwritesExisting: {
        actual: (
            core.Service
            .WithSelector({overwritten: 'label'})
            .WithSelector({test: 'true'})
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {
                selector: {test: 'true'},
            },
        },
    },
    testServiceWithType: {
        actual: core.Service.WithType('test'),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {type: 'test'},
        },
    },
    testServiceWithTypeOverwritesExisting: {
        actual: (
            core.Service
            .WithType('overwritten')
            .WithType('test')
        ),
        expect: {
            apiVersion: 'v1',
            kind: 'Service',
            spec: {type: 'test'},
        },
    },

    testServiceAccount: {
        actual: core.ServiceAccount,
        expect: {apiVersion: 'v1', kind: 'ServiceAccount'},
    },
})
