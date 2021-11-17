#!/bin/bash

OWNER=$OWNER
REPO=$REPO
REG_TOKEN=$REG_TOKEN
LABELS=${LABELS-"self-hosted"}

cd /opt/actions-runner


if [ ! -f ".runner" ]; then
	./config.sh --url https://github.com/${OWNER}/${REPO} --token ${REG_TOKEN} --labels ${LABELS} --unattended
fi

./run.sh & wait $!
