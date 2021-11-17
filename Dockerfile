FROM ubuntu

ARG RUNNER_VERSION="2.284.0"

RUN apt-get update -y \
    && apt-get upgrade -y \
    && useradd -m docker

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    jq \
    build-essential \
    git \
    gcc \
    make \
    openjdk-8-jdk-headless \
    ant \
    mtools \
    dosfstools \
    zip

WORKDIR /home/docker/actions-runner

# download and unzip the github actions runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && DEBIAN_FRONTEND=noninteractive /home/docker/actions-runner/bin/installdependencies.sh \
    && chown -R docker ~docker

WORKDIR /home/docker

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

# download and extract gcc arm compiler
RUN curl -L -O https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
    && tar -xf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
    && rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

ENV PATH $PATH:/home/docker/gcc-arm-none-eabi-9-2020-q2-update/bin

ENTRYPOINT ["./start.sh"]
