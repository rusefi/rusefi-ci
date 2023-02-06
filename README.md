# rusefi-ci

This dockerfile will automatically download and configure the github actions self-hosted runner

To run, first build the image with:

`docker build -t rusefi-ci .`

Then run the newly built image.

```bash
docker run --detach \
    -e RUNNER_NAME=test-runner2 \
    -e RUNNER_LABELS=ubuntu-latest \
    -e GITHUB_ACCESS_TOKEN=<Personal Access Token> \
    -e RUNNER_REPOSITORY_URL=https://github.com/ZHoob2004/rusefi \
    rusefi-ci
```

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

* via `GITHUB_ACCESS_TOKEN` (recommended), containing a [Personnal Access Token](https://github.com/settings/tokens). This token will be used to dynamically fetch a new runner token, as runner tokens are valid for a short period of time.
  * For a single-repository runner, your PAT should have `repo` scopes.
  * For an organization runner, your PAT should have `admin:org` scopes.
* via `RUNNER_TOKEN`. This token is displayed in the Actions settings page of your organization/repository, when opening the "Add Runner" page.
