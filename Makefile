REGISTRY_HOST=docker.io
USERNAME=ripl
#NAME=$(shell basename $(CURDIR))
NAME=lcm

IMAGE=$(USERNAME)/$(NAME)

RELEASE_VERSION = "1.5.0"

# Ubuntu versions are stored in the .env file
include .env
#UBUNTU_VERSION_LATEST = "20.04"
#UBUNTU_VERSION_PREVIOUS = "18.04"

# Base environments
BASE_IMAGE_ENVIRONMENT_LATEST = "nvidia/opengl:1.0-glvnd-devel-ubuntu${UBUNTU_VERSION_LATEST}"
BASE_IMAGE_ENVIRONMENT_PREVIOUS = "nvidia/opengl:1.0-glvnd-devel-ubuntu${UBUNTU_VERSION_PREVIOUS}"


# Tag: latest
BUILD_IMAGE_LATEST = $(IMAGE):latest
BUILD_IMAGE_PREVIOUS = $(IMAGE):${UBUNTU_VERSION_PREVIOUS}


.PHONY: pre-build docker-build build release showver \
	push cleanup

build: pre-build docker-build ## builds a new version of the container image(s)

pre-build: ## Update the base environment images
	docker pull $(BASE_IMAGE_ENVIRONMENT_LATEST)
	docker pull $(BASE_IMAGE_ENVIRONMENT_PREVIOUS)



post-build:


pre-push:


post-push:


docker-build:

	# Build latest
	docker buildx build --build-arg="UBUNTU_VERSION=${UBUNTU_VERSION_LATEST}" --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .

	# Build previous
	docker buildx build --build-arg="UBUNTU_VERSION=${UBUNTU_VERSION_PREVIOUS}" --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag $(BUILD_IMAGE_PREVIOUS) -f Dockerfile .


release: build push	## builds a new version of your container image(s), and pushes it/them to the registry


push: pre-push do-push post-push ## pushes the images to dockerhub

do-push: 
	# Push lateset
	docker buildx build --build-arg="UBUNTU_VERSION=${UBUNTU_VERSION_LATEST}" --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --push --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .

	# Push previous
	docker buildx build --build-arg="UBUNTU_VERSION=${UBUNTU_VERSION_PREVIOUS}" --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --push --tag $(BUILD_IMAGE_PREVIOUS) -f Dockerfile .


cleanup: ## Remove images pulled/generated as part of the build process
	docker rmi $(BUILD_IMAGE_LATEST)
	docker rmi $(BUILD_IMAGE_PREVIOUS)
	docker rmi $(BASE_IMAGE_ENVIRONMENT_LATEST)
	docker rmi $(BASE_IMAGE_ENVIRONMENT_PREVIOUS)


showver:	## shows the current release tag based on the workspace
	echo "RELEASE_VERSION: $(RELEASE_VERSION)"


help:           ## show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/printf '"'%-20s - %s\\\\n' '\1' '\2'"'/' |bash