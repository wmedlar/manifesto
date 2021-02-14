[
    {
        apiVersion: 'kubeadm.k8s.io/v1beta2',
        kind: 'ClusterConfiguration',
        kubernetesVersion: 'v1.20.1',
        networking: {
            podSubnet: '10.244.0.0/16',
        },
    },
    {
        apiVersion: 'kubeadm.k8s.io/v1beta2',
        kind: 'InitConfiguration',
        nodeRegistration: {
            taints: [],
        },
    },
    {
        apiVersion: 'kubelet.config.k8s.io/v1beta1',
        kind: 'KubeletConfiguration',
        serverTLSBootstrap: true,
    },
    {
        apiVersion: 'kubeproxy.config.k8s.io/v1alpha1',
        kind: 'KubeProxyConfiguration',
        mode: 'ipvs',
        ipvs: {
            scheduler: 'lc',
            strictARP: true,
        },
    },
]
