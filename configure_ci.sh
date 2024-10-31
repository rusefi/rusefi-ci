#!/bin/bash
echo "--------------------------------------------------------------"
echo "Step 1/5, OS setup"

source scripts/01_setup_OS.sh || { exit 1; }
echo "--------------------------------------------------------------"

echo "Step 2/5, pulling/creating base runner container"

source scripts/02_setup_runner_container.sh || { exit 1; }
echo "--------------------------------------------------------------"
