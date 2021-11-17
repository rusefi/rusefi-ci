# rusefi-ci

This script will automatically download and configure the github actions self-hosted runner and dynamically register it to the repo given in $OWNER/$REPO

To run, first build the image with:

`docker build -t rusefi-ci .`

Then run the newly built image passing `OWNER`, `REPO`, and `ACCESS_TOKEN` (your personal github access token, keep this safe!)

```bash
docker run --detach \
 --ENV OWNER=ZHoob2004 \
 --ENV REPO=rusefi \
 --ENV ACCESS_TOKEN=<PUT YO TOKEN HERE AND KEEP IT SECRET> \
 rusefi-ci
 ```
