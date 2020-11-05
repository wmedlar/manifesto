jsonnet_files := $(wildcard *.jsonnet)   $(wildcard */*.jsonnet)
jsonnet_files += $(wildcard *.libsonnet) $(wildcard */*.libsonnet)

jsonnetfmt_flags := --in-place
jsonnetfmt_flags += --indent 4
jsonnetfmt_flags += --no-pad-objects

.PHONY: fmt
fmt: $(jsonnet_files)

$(jsonnet_files): FORCE
	jsonnetfmt $(jsonnetfmt_flags) -- "$@"

FORCE: ;
