FROM ubuntu:22.04 AS builder

ARG RUNNER_VERSION="2.301.1"

WORKDIR /build

COPY start.sh /opt/start.sh

ADD https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz /build/

ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 /build/

RUN apt-get update &&\
    apt-get install bzip2 &&\
    mkdir -p /opt/actions-runner &&\
    tar -xf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /opt/actions-runner/ &&\
    tar -xf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 &&\
    chmod +x /opt/start.sh



FROM ubuntu:22.04 AS actions-runer

COPY --from=builder /opt /opt
COPY --from=builder /build/gcc-arm-none-eabi-9-2020-q2-update/bin /bin

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
    && apt-get autoremove -y && apt-get clean -y &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers &&\
    echo 'APT::Get::Assume-Yes "true";' >/etc/apt/apt.conf.d/90forceyes &&\
    chown -R docker /opt

WORKDIR /opt

USER docker

VOLUME /opt/actions-runner

ENTRYPOINT ["./start.sh"]
