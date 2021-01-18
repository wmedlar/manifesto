local meta = import 'meta.libsonnet';

{
    Group:: 'core',
    Version:: 'v1',
    Object:: meta.Object.WithAPIVersion($.Group, $.Version),
}
