{
    local core = import 'core.libsonnet',
    ConfigMap:: core.ConfigMap,
    Container:: core.Container,
    Endpoints:: core.Endpoints,
    Event:: core.Event,
    LimitRange:: core.LimitRange,
    List:: core.List,
    Namespace:: core.Namespace,
    Node:: core.Node,
    PersistentVolume:: core.PersistentVolume,
    PersistentVolumeClaim:: core.PersistentVolumeClaim,
    Pod:: core.Pod,
    PodTemplate:: core.PodTemplate,
    ResourceQuota:: core.ResourceQuota,
    Secret:: core.Secret,
    Service:: core.Service,
    ServiceAccount:: core.ServiceAccount,
}
