FROM ubuntu:24.04

# Install systemd and basic tools
RUN apt-get update && \
    apt-get -y install \
        systemd \
        passwd \
        sudo \
        python3 \
        # iproute \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Necessary for systemd in Docker
VOLUME [ "/sys/fs/cgroup" ]
STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]