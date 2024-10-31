#!/bin/bash

LABEL=${2:-"ubuntu-latest"}
IMAGE_HASH=$(docker image inspect rusefi-ci --format "{{.Id}}" 2>/dev/null)

read -p "Enter the rusEFI board serial ID: " HARDWARE_CI_SERIAL
read -p "Enter the STLink ID: " HARDWARE_CI_STLINK_SERIAL
read -p "Enter the CI VBATT: " HARDWARE_CI_VBATT

echo "go to: https://github.com/FDSoftware/rusefi/settings/actions/runners/new and get a new runner token"
read -p "Enter your runner token: " RUNNER_TOKEN

DOCKER_RUNNER_IMAGE=$(docker images | grep -ioh "\S*rusefi-ci\S*" | head -1)

if CONTAINER_HASH=$(docker container inspect $RUNNER_NAME --format "{{.Image}}" 2>/dev/null) && [ "$IMAGE_HASH" = "$CONTAINER_HASH" ]; then
    echo "There is already a runner with the same configuration, skipping"
    docker start -i "$RUNNER_NAME"
else
    if docker container inspect "$RUNNER_NAME" >/dev/null 2>/dev/null; then
        echo "existing runner but there is a more recent base image, recreating"
        docker rm "$RUNNER_NAME"
    fi
    if [ -n "$3" ]; then
        MOUNT="-v $PWD/$3:/opt/actions-runner/rusefi-env:ro"
    fi

    #TODO: remove references to personal repo
    docker run --name $RUNNER_NAME --detach --privileged --restart=unless-stopped $MOUNT \
        -e RUNNER_NAME="$RUNNER_NAME" \
        -e RUNNER_LABELS="$LABEL" \
        -e RUNNER_TOKEN="$RUNNER_TOKEN" \
        -e HARDWARE_CI_SERIAL="$HARDWARE_CI_SERIAL" \
        -e HARDWARE_CI_STLINK_SERIAL="$HARDWARE_CI_STLINK_SERIAL" \
        -e HARDWARE_CI_VBATT="$HARDWARE_CI_VBATT" \
        -e RUNNER_REPOSITORY_URL=https://github.com/FDSoftware/rusefi \
        "$DOCKER_RUNNER_IMAGE:main"
fi
