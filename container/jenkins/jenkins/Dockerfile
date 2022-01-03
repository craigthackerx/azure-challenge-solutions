FROM jenkins:latest

ENV NORMAL_USER jenkins

USER root

RUN  export DEBIAN_FRONTEND=noninteractive && \
apt-get update -y && apt-get dist-upgrade -y && apt-get install -y \
curl \
python3-pip \
git \
jq \
wget \
unzip && \
      terraformLatestVersion=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep -v 'rc|beta|alpha' | egrep 'linux.*amd64'  | tail -1) && \
         wget "${terraformLatestVersion}" && \
         unzip terraform* && rm -rf terraform*..zip && \
         mv terraform /usr/local/bin

USER ${NORMAL_USER}

ENV PATH="/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${NORMAL_USER}/.local/bin:${PATH}"

RUN  pip3 install checkov && \
            pip3 install --upgrade checkov && \
                pip3 install azure-cli && \
                pip3 install --upgrade azure-cli && \
                    pip3 install terraform-compliance && \
                    pip3 install --upgrade terraform-compliance


