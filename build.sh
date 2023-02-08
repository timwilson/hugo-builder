#!/bin/bash

# Build the Hugo container
echo Building klakegg/hugo container ...
docker image build . -f Dockerfile-build -t hugo-site
code .
