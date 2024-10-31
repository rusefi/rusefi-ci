#!/bin/bash

NAME="runner-$1"
LABEL=${2:-"ubuntu-latest"}
IMAGE_HASH=$(docker image inspect rusefi-ci --format "{{.Id}}" 2>/dev/null)


# antes de crear el runner falta:
# reglas udev en caso de ser necesario
# probar conexion con STLink
# probar conexion con pcb de rusefi


if CONTAINER_HASH=$(docker container inspect $NAME --format "{{.Image}}" 2>/dev/null) && [ "$IMAGE_HASH" = "$CONTAINER_HASH" ]; then
    echo "There is already a runner with the same configuration, skipping"
    docker start -i "$NAME"
else
    if docker container inspect "$NAME" >/dev/null 2>/dev/null; then
        echo "existing runner but there is a more recent base image, recreating"
        docker rm "$NAME"
    fi
    if [ -n "$3" ]; then
        MOUNT="-v $PWD/$3:/opt/actions-runner/rusefi-env:ro"
    fi

    #TODO: remove references to personal repo
    docker run --name $NAME --detach --privileged --restart=unless-stopped $MOUNT \
        -e RUNNER_NAME="$NAME" \
        -e RUNNER_LABELS="$LABEL" \
        -e RUNNER_TOKEN="$RUNNER_TOKEN" \
        -e RUNNER_REPOSITORY_URL=https://github.com/FDSoftware/rusefi \
        rusefi-ci
fi
