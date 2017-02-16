#!/usr/bin/env make
PROJECT := overcommit
VERSION := 0.38.0-0

# Declare all targets as phony targets
# https://www.gnu.org/software/make/manual/make.html#Phony-Targets
.PHONY: %

# By default, `make` without arguments runs the first target in the Makefile.
# Hence let's declare it explicitly.
_default: build

build:
	docker build \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		--tag harmjanblok/$(PROJECT):$(VERSION) \
		.

test:
	docker run \
		--rm \
		--volume $(shell pwd):/usr/src/app \
		harmjanblok/$(PROJECT):$(VERSION)
