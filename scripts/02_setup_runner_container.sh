#!/bin/bash

if docker pull ghcr.io/fdsoftware/rusefi-ci:main; then
    echo "remote docker container pull succeeded"
else
    echo "remote docker container pull failed, building image locally"
    docker build --build-arg GID=$(getent group docker | cut -d ':' -f 3) -t rusefi-ci:main .
fi
