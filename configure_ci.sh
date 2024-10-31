#!/bin/bash
echo "--------------------------------------------------------------"
echo "Step 1/5, OS setup"
source scripts/01_setup_OS.sh || { exit 1; }

echo "--------------------------------------------------------------"
echo "Step 2/5, pulling/creating base runner container"
source scripts/02_setup_runner_container.sh || { exit 1; }

echo "--------------------------------------------------------------"
echo "Step 3/5, updating udev rules"
source scripts/03_setup_udev_rules.sh || { exit 1; }

echo "--------------------------------------------------------------"
echo "Step 4/5, select rusefi board for the runner"
source scripts/04_clone_rusefi_board_definitions.sh || { exit 1; }

echo "--------------------------------------------------------------"
echo "Step 5/5, create the runner"
source scripts/05_create_new_runner.sh || { exit 1; }