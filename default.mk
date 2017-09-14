SHELL := /bin/bash

# all monitor components share/use the following targets/exports
BUILD_TAG ?= git-$(shell git rev-parse --short HEAD)
IMAGE_PREFIX ?= deis

include ./includes.mk
include ./versioning.mk

build: docker-build
push: docker-push
deploy: check-kubectl docker-build docker-push install

docker-build:
	docker build ${DOCKER_BUILD_FLAGS} -t ${IMAGE} ./telegraf/rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

clean: check-docker
	docker rmi $(IMAGE)

.PHONY: build push docker-build clean

build-all:
	docker build ${DOCKER_BUILD_FLAGS} -t ${DEV_REGISTRY}${IMAGE_PREFIX}/telegraf:${VERSION} ./telegraf/rootfs

push-all:
	docker push ${DEV_REGISTRY}${IMAGE_PREFIX}/telegraf:${VERSION}