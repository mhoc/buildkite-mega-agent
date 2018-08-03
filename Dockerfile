FROM buildkite/agent:latest
WORKDIR /setup

RUN apt-get update && apt-get upgrade -y

# Some basic things.
# gpg (which is necessary for checking the signatures of some future packages)
# wget (v nice)
# python (who doesn't like the latest python?)
# software-properties-common (includes add-apt-repository)
# build-essential (make!)
# jq (command line json processor)
RUN apt-get install -y gnupg wget python unzip software-properties-common build-essential jq

# aws-cli
RUN curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip \
  && unzip awscli-bundle.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# gcloud
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-210.0.0-linux-x86_64.tar.gz -o gcloud.tar.gz \
  && tar -C /setup -xzf gcloud.tar.gz \
  && sh ./google-cloud-sdk/install.sh
ENV PATH="/setup/google-cloud-sdk/bin:${PATH}"

# kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && touch /etc/apt/sources.list.d/kubernetes.list \
  && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update \
  && apt-get install -y kubectl

# kops
RUN wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
  && chmod +x ./kops \
  && mv ./kops /usr/local/bin/

# yq (a command line yaml processor)
RUN add-apt-repository ppa:rmescandon/yq \
  && apt-get update \
  && apt install yq -y

# Golang!
RUN curl -s https://dl.google.com/go/go1.11beta3.linux-amd64.tar.gz -o go.tar.gz \
  && tar -C /usr/local -xzf go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
