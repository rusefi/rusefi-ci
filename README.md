# rusefi-ci
As of October 2024 it's still https://github.com/rusefi/rusefi/wiki/Dev-Quality-Control#hardware-continuous-integration

Current status: WIP

This repository is used to create self-hosted GitHub runners, from a base image, created by a workflow in the same repository, to resolve the issue: https://github.com/rusefi/rusefi/issues/7012

Host requirements for the runners host:
* Ubuntu LTS
* any STLink or rusEFI board connected to the host will be redirected to the docker

To start, run the `start.sh` script that is responsible for installing all the dependencies for the runner. After the initial setup, you can re-create or add new runners with the same script.
Some steps, such as the selection of STLink/rusEFI board, were removed from the CI and moved to the creation of the runner as they are more static tasks.

For details on how to obtain STLink IDs refer to:
