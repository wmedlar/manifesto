local k8s = import 'lib/k8s.libsonnet';
local namespace = 'loadbalancing';
local name = 'metallb';

local config = {
    'address-pools': [{
        name: 'default',
        protocol: 'layer2',
        addresses: ['192.168.1.0/24'],
    }],
};

k8s.core.ConfigMap(namespace, name)
.WithData('config', std.manifestYamlDoc(config))
