local test = import 'external/jsonnetunit/jsonnetunit/test.libsonnet';

local core = import 'core.libsonnet';
local meta = import 'meta.libsonnet';

test.suite({
    testObjectWithAPIVersionCoreGroup: {
        actual: meta.Object.WithAPIVersion(core.Group, 'v1'),
        expect: {apiVersion: 'v1'},
    },
    testObjectWithAPIVersionNonCoreGroup: {
        actual: meta.Object.WithAPIVersion('test', 'v1'),
        expect: {apiVersion: 'test/v1'},
    },
    testObjectWithAPIVersionOverwritesExisting: {
        actual: (
            meta.Object
            .WithAPIVersion('overwritten', 'v1alpha1')
            .WithAPIVersion('test', 'v1')
        ),
        expect: {apiVersion: 'test/v1'},
    },
    testObjectWithAPIVersionProvidesAPIGroupMethod: {
        actual: meta.Object.WithAPIVersion('test', 'v1').APIGroup(),
        expect: 'test',
    },
    testObjectWithAPIVersionProvidesAPIVersionMethod: {
        actual: meta.Object.WithAPIVersion('test', 'v1').APIVersion(),
        expect: 'v1',
    },

    testObjectWithKind: {
        actual: meta.Object.WithKind('test'),
        expect: {kind: 'test'},
    },
    testObjectWithKindOverwritesExisting: {
        actual: (
            meta.Object
            .WithKind('overwritten')
            .WithKind('test')
        ),
        expect: {kind: 'test'},
    },

    testObjectWithAnnotation: {
        actual: meta.Object.WithAnnotation('key', 'value'),
        expect: {metadata: {annotations: {key: 'value'}}},
    },
    testObjectWithAnnotationMergesExisting: {
        actual: (
            meta.Object
            .WithAnnotation('key', 'value')
            .WithAnnotation('appended', 'true')
        ),
        expect: {metadata: {annotations: {key: 'value', appended: 'true'}}},
    },

    testObjectWithLabel: {
        actual: meta.Object.WithLabel('key', 'value'),
        expect: {metadata: {labels: {key: 'value'}}},
    },
    testObjectWithLabelMergesExisting: {
        actual: (
            meta.Object
            .WithLabel('key', 'value')
            .WithLabel('appended', 'true')
        ),
        expect: {metadata: {labels: {key: 'value', appended: 'true'}}},
    },

    // Test default behavior of Object.WithName.
    testObjectWithName: {
        actual: meta.Object.WithName('test'),
        expect: {metadata: {name: 'test'}},
    },
    testObjectWithNameOverwritesExisting: {
        actual: (
            meta.Object
            .WithName('ovewritten')
            .WithName('test')
        ),
        expect: {metadata: {name: 'test'}},
    },
    testObjectWithNameProvidesNameMethod: {
        actual: meta.Object.WithName('test').Name(),
        expect: 'test',
    },
    // Test behavior of Object.WithName(..., generate=true).
    testObjectWithNameGenerateTrue: {
        actual: meta.Object.WithName('test', generate=true),
        expect: {metadata: {generateName: 'test'}},
    },
    testObjectWithNameGenerateTrueOverwritesExisting: {
        actual: (
            meta.Object
            .WithName('ovewritten', generate=true)
            .WithName('test', generate=true)
        ),
        expect: {metadata: {generateName: 'test'}},
    },
    testObjectWithNameGenerateMixedMergesExisting: {
        actual: (
            meta.Object
            .WithName('name')
            .WithName('generate', generate=true)
        ),
        expect: {metadata: {generateName: 'generate', name: 'name'}},
    },
    testObjectWithNameGenerateTrueProvidesNameMethod: {
        actual: meta.Object.WithName('test', generate=true).Name(),
        expect: 'test',
    },

    testObjectWithNamespace: {
        actual: meta.Object.WithNamespace('test'),
        expect: {metadata: {namespace: 'test'}},
    },
    testObjectWithNamespaceOverwritesExisting: {
        actual: (
            meta.Object
            .WithNamespace('overwritten')
            .WithNamespace('test')
        ),
        expect: {metadata: {namespace: 'test'}},
    },
    testObjectWithNamespaceProvidesNamespaceMethod: {
        actual: meta.Object.WithNamespace('test').Namespace(),
        expect: 'test',
    },
})
