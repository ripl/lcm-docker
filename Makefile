REGISTRY_HOST=docker.io
USERNAME=ripl
#NAME=$(shell basename $(CURDIR))
NAME=lcm

IMAGE=$(USERNAME)/$(NAME)

RELEASE_VERSION = "1.5.0"

# Use two base environments
#     latest supported LTS
BASE_IMAGE_ENVIRONMENT = "nvidia/opengl:1.0-glvnd-devel-ubuntu20.04"

#     previously supported LTS   
#BASE_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS = "nvidia/opengl:1.0-glvnd-devel-ubuntu18.04"
#PREVIOUS_UBUNTU_LTS = "bionic"

# Tag: environment
#BUILD_IMAGE_ENVIRONMENT = $(IMAGE):environment

# Tag: environment_bionic
#BUILD_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS = $(IMAGE):environment_$(PREVIOUS_UBUNTU_LTS)

# Tag: latest
BUILD_IMAGE_LATEST = $(IMAGE):latest

# Tag: release
#BUILD_IMAGE_RELEASE = $(IMAGE):$(RELEASE_VERSION)

# Tag: latest_PREVIOUS_UBUNTU_LTS
#BUILD_IMAGE_LATEST_PREVIOUS_UBUNTU_LTS = $(IMAGE):latest_$(PREVIOUS_UBUNTU_LTS)

# Tag: <release>_PREVIOUS_UBUNTU_LTS
#BUILD_IMAGE_RELEASE_PREVIOUS_UBUNTU_LTS = $(IMAGE):$(RELEASE_VERSION)_$(PREVIOUS_UBUNTU_LTS)



.PHONY: pre-build docker-build build release showver \
	push cleanup

build: pre-build docker-build ## builds a new version of the container image(s)

pre-build: ## Update the base environment images
	docker pull $(BASE_IMAGE_ENVIRONMENT)
	#docker pull $(BASE_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS)


post-build:


pre-push:


post-push:



docker-build:

	docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .
	
	#docker build -t $(BUILD_IMAGE_ENVIRONMENT) -f Dockerfile.environment ./
	
	#docker build -t $(BUILD_IMAGE_LATEST) -f Dockerfile.latest ./
	
	#docker build -t $(BUILD_IMAGE_RELEASE) --build-arg VERSION=$(RELEASE_VERSION) -f Dockerfile.release ./

	#docker build -t $(BUILD_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS) -f Dockerfile.environment_previous_ubuntu_lts ./
	
	#docker build -t $(BUILD_IMAGE_LATEST_PREVIOUS_UBUNTU_LTS) -f Dockerfile.latest_previous_ubuntu_lts ./
	
	#docker build -t $(BUILD_IMAGE_RELEASE_PREVIOUS_UBUNTU_LTS) --build-arg VERSION=$(RELEASE_VERSION) -f Dockerfile.release_previous_ubuntu_lts ./


release: build push	## builds a new version of your container image(s), and pushes it/them to the registry


push: pre-push do-push post-push 

do-push: 
	docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --push --tag $(BUILD_IMAGE_LATEST) -f Dockerfile .
	#docker push $(BUILD_IMAGE_LATEST)
	#docker push $(BUILD_IMAGE_RELEASE)
	#docker push $(BUILD_IMAGE_LATEST_PREVIOUS_UBUNTU_LTS)
	#docker push $(BUILD_IMAGE_RELEASE_PREVIOUS_UBUNTU_LTS)

cleanup: ## Remove images pulled/generated as part of the build process
	#docker rmi $(BUILD_IMAGE_RELEASE)
	docker rmi $(BUILD_IMAGE_LATEST)
	#docker rmi $(BUILD_IMAGE_ENVIRONMENT)
	docker rmi $(BASE_IMAGE_ENVIRONMENT)
	#docker rmi $(BUILD_IMAGE_RELEASE_PREVIOUS_UBUNTU_LTS)
	#docker rmi $(BUILD_IMAGE_LATEST_PREVIOUS_UBUNTU_LTS)
	#docker rmi $(BUILD_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS)
	#docker rmi $(BASE_IMAGE_ENVIRONMENT_PREVIOUS_UBUNTU_LTS)


showver:	## shows the current release tag based on the workspace
	echo "RELEASE_VERSION: $(RELEASE_VERSION)"


help:           ## show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/printf '"'%-20s - %s\\\\n' '\1' '\2'"'/' |bash