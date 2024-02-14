REGISTRY_HOST=docker.io
USERNAME=ripl
#NAME=$(shell basename $(CURDIR))
NAME=lcm

IMAGE=$(USERNAME)/$(NAME)

RELEASE_VERSION = "1.5.0"

# Use two base environments
#     latest supported LTS
BASE_IMAGE_ENVIRONMENT = "nvidia/opengl:1.0-glvnd-devel-ubuntu20.04"

# Tag: latest
BUILD_IMAGE_LATEST = $(IMAGE):latest


.PHONY: pre-build docker-build build release showver \
	push cleanup

build: pre-build docker-build ## builds a new version of the container image(s)

pre-build: ## Update the base environment images
	docker pull $(BASE_IMAGE_ENVIRONMENT)


post-build:


pre-push:


post-push:



docker-build:

	docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .


release: build push	## builds a new version of your container image(s), and pushes it/them to the registry


push: pre-push do-push post-push 

do-push: 
	docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --push --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .

cleanup: ## Remove images pulled/generated as part of the build process
	docker rmi $(BUILD_IMAGE_LATEST)
	docker rmi $(BASE_IMAGE_ENVIRONMENT)


showver:	## shows the current release tag based on the workspace
	echo "RELEASE_VERSION: $(RELEASE_VERSION)"


help:           ## show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/printf '"'%-20s - %s\\\\n' '\1' '\2'"'/' |bash