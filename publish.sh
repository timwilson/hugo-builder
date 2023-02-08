#!/bin/bash

# Use the name of the parent directory for the docker image name
IMAGE_NAME=$(basename $PWD)
DOCKER_HUB_USERNAME=timothydwilson
TAGGED_IMAGE_NAME=$DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

# Build the container
echo Exporting website to Caddy image ...
docker image build . -f Dockerfile-publish -t $IMAGE_NAME
docker image tag $IMAGE_NAME $TAGGED_IMAGE_NAME
echo Pushing to hub.docker.com ...
docker push $TAGGED_IMAGE_NAME
