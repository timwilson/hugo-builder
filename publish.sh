#!/bin/bash

# This script makes it possible to build a new container containing the
# website contents and deploy it for production use or local testing.
# 
# To publish to hub.docker.com:
# $ ./publish.sh production
#
# To build a copy for local testing:
# $ ./publish.sh test
#
# Build a local copy of the image without pushing or launching it
# $ ./publish.sh local
#
# Set the following to your username at http://hub.docker.com/
DOCKER_HUB_USERNAME=

BUILD_MODE=$1   # Get commandline argument
# Use the name of the parent directory for the docker image name
IMAGE_NAME=$(basename $PWD)
TAGGED_IMAGE_NAME=$DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

default_build () {
	echo "Beginning local hugo build ..."
	# Run Hugo one more time to make sure the site gets built from the
	# most current markdown files.
	docker run \
		--rm \
		-it \
		-v $(PWD)/www:/src \
		--entrypoint hugo \
		klakegg/hugo:ext-debian
	# Build the image
	docker image build -f Dockerfile.publish -t $TAGGED_IMAGE_NAME .
	echo "Image $TAGGED_IMAGE_NAME created ..."
}

show_help () {
	echo "Usage: ./publish.sh [ production | test | local ]"
}

# Check for commandline input and build the container accordingly.
if [ $# -eq 0 ]; then
	show_help

elif [ $BUILD_MODE == "production" ]; then
	echo "Beginning local hugo build ..."
	# Run Hugo one more time to make sure the site gets built from the
	# most current markdown files in "production" mode.
	docker run \
		--rm \
		-it \
		--env HUGO_ENV=production \
		-v $(PWD)/www:/src \
		--entrypoint hugo \
		klakegg/hugo:ext-debian

	echo "Beginning production image build ..."
	# Utilize buildx to create a multi-platform build
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-f Dockerfile.publish \
		-t $TAGGED_IMAGE_NAME \
		. --push
	echo "Production image ($TAGGED_IMAGE_NAME) created and pushed to hub.docker.com ..."

elif [ $BUILD_MODE == "test" ]; then
	echo "Rebuilding website for local testing ..."
	# Run Hugo one more time to make sure the site gets built from the
	# most current markdown files.
	docker run \
		--rm \
		-it \
		-v $(PWD)/www:/src \
		--entrypoint hugo \
		klakegg/hugo:ext-debian
		
	echo "Beginning test build ..."
	docker build \
		--platform linux/arm64 \
		--build-arg CADDY_SRC="Caddyfile.local" \
		-f Dockerfile.publish \
		-t $TAGGED_IMAGE_NAME \
		.
	echo "Build complete, tagged $TAGGED_IMAGE_NAME ... "
	docker run \
		--rm \
		-d \
		-p 80:80 \
		$TAGGED_IMAGE_NAME
	echo "Container running at http://localhost/ ..."
else
	default_build
fi
