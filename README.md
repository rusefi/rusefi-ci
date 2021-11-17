# rusefi-ci

This script will automatically download and configure the github actions self-hosted runner

To run, first build the image with:

`docker build -t rusefi-ci .`

Then run the newly built image passing `OWNER`, `REPO`, and `REG_TOKEN` (time-limited github actions registration token)

```bash
docker run --detach \
 --ENV OWNER=ZHoob2004 \
 --ENV REPO=rusefi \
 --ENV REG_TOKEN=<PUT YO TOKEN HERE> \
 rusefi-ci
 ```

add `--restart=unless-stopped` in order to have the container survive reboots


The container uses a persistent volume mounted at /opt/actions-runner. After initial startup, the container will skip registration unless the peristent volume is erased.
