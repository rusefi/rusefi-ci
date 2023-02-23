# rusefi-ci

This dockerfile will automatically download and configure the github actions self-hosted runner

To run, first build the image with:

`docker build --build-arg GID=$(getent group docker | cut -d ':' -f 3) -t rusefi-ci .`

Then run the newly built image.

```bash
docker run --detach --privileged \
    -e RUNNER_NAME=test-runner2 \
    -e RUNNER_LABELS=ubuntu-latest \
    -e GITHUB_ACCESS_TOKEN=<Personal Access Token> \
    -e RUNNER_REPOSITORY_URL=https://github.com/<github user>/rusefi \
    rusefi-ci
```
Replace `<github user>` with your own username if you are running on your own fork.
If you are running an organization-level runner, you will need to replace `RUNNER_REPOSITORY_URL` with `RUNNER_ORGANIZATION_URL`.


Add `--restart=unless-stopped` in order to have the container survive reboots

The container uses a persistent volume mounted at /opt/actions-runner. After initial startup, the container will skip registration unless the peristent volume is erased.

## Environment variables

The following environment variables allows you to control the configuration parameters.

| Name | Description | Required/Default value |
|------|---------------|-------------|
| RUNNER_REPOSITORY_URL | The runner will be linked to this repository URL | Required if `RUNNER_ORGANIZATION_URL` is not provided |
| RUNNER_ORGANIZATION_URL | The runner will be linked to this organization URL. *(Self-hosted runners API for organizations is currently in public beta and subject to changes)* | Required if `RUNNER_REPOSITORY_URL` is not provided |
| GITHUB_ACCESS_TOKEN | Personal Access Token. Used to dynamically fetch a new runner token (recommended, see below). | Required if `RUNNER_TOKEN` is not provided.
| RUNNER_TOKEN | Runner token provided by GitHub in the Actions page. These tokens are valid for a short period. | Required if `GITHUB_ACCESS_TOKEN` is not provided
| RUNNER_WORK_DIRECTORY | Runner's work directory | `"_work"`
| RUNNER_NAME | Name of the runner displayed in the GitHub UI | Hostname of the container
| RUNNER_LABELS | Extra labels in addition to the default: 'self-hosted,Linux,X64' (based on your OS and architecture) | `""`
| RUNNER_REPLACE_EXISTING | `"true"` will replace existing runner with the same name, `"false"` will use a random name if there is conflict | `"true"`

## Runner Token

In order to link your runner to your repository/organization, you need to provide a token. There is two way of passing the token :

* via `GITHUB_ACCESS_TOKEN` (recommended), containing a [fine-grained Personnal Access Token](https://github.com/settings/tokens). This token will be used to dynamically fetch a new runner token, as runner tokens are valid for a short period of time.
  * For a single-repository runner, select the repository under "Only select repositories", then under "Repository Permissions" set "Administration" to read-write.
  * For an organization runner, select the repository and set "Organization self hosted runners"to read-write.
* via `RUNNER_TOKEN`. This token is displayed in the Actions settings page of your organization/repository, when opening the "Add Runner" page.

## Helper Functions

If you stop and start workes often, you may find it useful to have a function for starting workers. I have added the below functions to my .bashrc:

```bash
ghatoken ()
{
 echo -n "Paste token:"
 read TOKEN
 KEY=$(echo "$TOKEN" | openssl enc -aes-256-cbc -a | tr -d '\n')
 perl -pi -e 's#(?<=TOKEN=\$\(echo\s").*?(?="\s\|)#'"$KEY"'#' $(realpath ~/.bashrc)
}

gha ()
{
  TOKEN=$(echo "U2FsdGVkX1/bq53NjBMtWxIiCE0gzVtrqzPjgAlyPziyVcc3OCkF0HUrg1LcMTfb74Yrs7p2HBmISrqYSOZF2B1jZ1y6hvF4I7/GyXUFFTKMTg7gjJCfjJwo0ShFTGBqan/xWZiZKqIUsrHPN5V3EA==" | openssl enc -aes-256-cbc -a -d)
  docker run -it --privileged -e RUNNER_NAME=runner-$1 -e RUNNER_LABELS=ubuntu-latest -e GITHUB_ACCESS_TOKEN="$TOKEN" -e RUNNER_REPOSITORY_URL=https://github.com/<github user>/rusefi rusefi-ci
}
```

Replace `<github user>` with your own username if you are running on your own fork.
If you are running an organization-level runner, you will need to replace `RUNNER_REPOSITORY_URL` with `RUNNER_ORGANIZATION_URL`.

Once the functions are in your .bashrc, and you have sourced your .bashrc, by opening a new shell or by running `. ~/.bashrc`,
run `ghatoken`, paste in your PAT, and enter a password. This password will be used every time you start a runner.

After you have run `ghatoken`, you can now start runners with `gha <id>`. I use sequential ids, e.g. `gha 1`, `gha 2`, etc,
but you may name them however you like.
