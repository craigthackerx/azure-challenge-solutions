#!/usr/bin/env bash

[ "$(whoami)" = root ] || { sudo "$0" "$@"; exit $?; }

set -xeuo pipefail

timedatectl set-timezone Europe/London && \
firewall-cmd --zone=public --add-port=8080/tcp && \
firewall-cmd --zone=public --add-port=8090/tcp && \
firewall-cmd --reload && \
loginctl enable-linger 1000 && \

yum update -y && \
yum install -y \
  podman \
  python3-pip \
  git \
  yum-utils \
  dnf-plugins-core \
  curl \
  zip \
  unzip \
  openssl && \

yum clean all


   if [ "$(command -v pip3)" ]; then

     export PATH=$PATH:~/.local/bin && \

     git clone https://github.com/craigthackerx/azure-challenge-solutions.git && \

     pip3 install --user podman-compose && \

     rm -rf azure-challenge-solutions && \
     cd azure-challenge-solutions/container/podman/grafana && \
     mkdir -p grafana-data && \
     echo "The VM is now setup." && \

     cd .. && podman-compose up -d

   else
     echo "Error running user script"
   fi
