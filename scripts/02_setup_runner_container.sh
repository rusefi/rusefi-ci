#!/bin/bash

docker pull ghcr.io/fdsoftware/rusefi-ci
# should build the image locally if the pull fails?
#docker build --build-arg GID=$(getent group docker | cut -d ':' -f 3) -t rusefi-ci .