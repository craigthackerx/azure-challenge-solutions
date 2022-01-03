#!/usr/bin/env bash

[ "$(whoami)" = root ] || { sudo "$0" "$@"; exit $?; }

#Using bash strict mode causes sourcing the bashrc to fail so exporting path becomes harder when executing cloud-init
set -xeuo pipefail

#It's normally not a good idea to execute containers as root, but I am doing so for this challenge as non-root in Oracle Linux is alien to me.
cd /root

yum update -y && \
    yum install -y \
    curl \
    podman \
    python3-pip \
    git && \

    timedatectl set-timezone Europe/London && \
    firewall-cmd --zone=public --add-port=8080/tcp && \
    firewall-cmd --zone=public --add-port=8090/tcp && \
    firewall-cmd --reload && \
    loginctl enable-linger 1000


if [ "$(command -v pip3)" ]; then

        /bin/pip3 install podman-compose && \

        rm -rf azure-challenge-solutions && \
        /bin/git clone https://github.com/craigthackerx/azure-challenge-solutions.git && \
        cd azure-challenge-solutions/container/podman/grafana && \
        mkdir -p grafana-data && \
        echo "The VM is now setup." && \

        yum clean all && \

        cd .. && /root/.local/bin/podman-compose up -d && exit 0

else
    echo "Error running user script" && exit 1
fi
