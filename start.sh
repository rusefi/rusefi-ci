#!/bin/bash

OWNER=$OWNER
REPO=$REPO
REG_TOKEN=$REG_TOKEN

cd /opt/actions-runner


if [ ! -f ".runner" ]; then
	./config.sh --url https://github.com/${OWNER}/${REPO} --token ${REG_TOKEN} --unattended
fi

./run.sh & wait $!
