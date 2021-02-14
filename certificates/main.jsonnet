local cainjector = import 'lib/cainjector.libsonnet';
local controller = import 'lib/controller.libsonnet';
local issuers = import 'lib/issuers.libsonnet';
local webhook = import 'lib/webhook.libsonnet';
local namespace = 'certificates';

{
    'cainjector.json': cainjector.List(namespace),
    'controller.json': controller.List(namespace),
    'issuers.json': issuers.List(namespace),
    'webhook.json': webhook.List(namespace),
}
