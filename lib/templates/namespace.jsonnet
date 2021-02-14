local k8s = import 'lib/k8s.libsonnet';

k8s.core.Namespace('$name')
