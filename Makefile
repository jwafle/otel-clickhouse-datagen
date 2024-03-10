.PHONY: default build build-linux run-docker generate-mac generate-linux

VERSION ?= $(shell git describe --tags 2>/dev/null)
ifeq ($(VERSION),)
VERSION := $(shell git rev-parse HEAD)
endif

GENERATE_DIR = ./generated

OCB_VERSION=0.95.0
OCB_MAC=ocb_darwin
OCB_LINUX=ocb_linux

OUTPUT = otel-clickhouse-datagen
GO_SOURCES = $(shell find $(GENERATE_DIR) -type f -name '*.go') $(GENERATE_DIR)/go.mid

# default to running a build
default: build

build: ${OUTPUT}

build-linux: linux-${OUTPUT}-${VERSION}

${OUTPUT}: generate-mac ${GO_SOURCES}
	cd $(GENERATE_DIR) && \
	GOSUMDB=off go get -v && \
	GOSUMDB=off GO111MODULE=on go build -o ${OUTPUT} .