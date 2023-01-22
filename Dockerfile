FROM ubuntu:22.04 AS builder

ARG RUNNER_VERSION="2.301.1"

WORKDIR /build

COPY start.sh /opt/start.sh

ADD https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz /build/

ADD https://github.com/rusefi/build_support/raw/master/rusefi-arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz /build/

RUN apt-get update &&\
    apt-get install xz-utils &&\
    mkdir -p /opt/actions-runner &&\
    tar -xf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /opt/actions-runner/ &&\
    tar -xf rusefi-arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz &&\
    chmod +x /opt/start.sh



FROM ubuntu:22.04 AS actions-runer

COPY --from=builder /opt /opt
COPY --from=builder /build/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin /bin

RUN useradd -m -g sudo docker &&\
    apt-get update -y &&\
    DEBIAN_FRONTEND=noninteractive /opt/actions-runner/bin/installdependencies.sh && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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
    zip \
    xxd \
    usbutils \
    openocd \
    sudo \
    ruby-rubygems \
    time \
    lsb-release \
    wget \
    file \
    netbase \
    && apt-get autoremove -y && apt-get clean -y &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers &&\
    echo 'APT::Get::Assume-Yes "true";' >/etc/apt/apt.conf.d/90forceyes &&\
    chown -R docker /opt

WORKDIR /opt

USER docker

VOLUME /opt/actions-runner

ENTRYPOINT ["./start.sh"]
