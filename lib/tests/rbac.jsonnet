local test = import 'external/jsonnetunit/jsonnetunit/test.libsonnet';
local core = import 'lib/rbac.libsonnet';

test.suite({
    testObject: {
        actual: core.Object,
        expect: {apiVersion: 'rbac.authorization.k8s.io/v1'},
    },
})
