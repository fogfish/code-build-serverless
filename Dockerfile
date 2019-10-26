FROM centos:7

##
## config docker-in-docker
RUN set -eu \
  && yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

COPY src/config-docker.sh /usr/local/bin/
COPY src/config.sh /usr/local/bin/

##
## config essential build tools
RUN set -eu \
   && curl --silent --location https://rpm.nodesource.com/setup_10.x | bash - \
   && yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
   && yum install -y \
      nodejs \
      git \
      autoconf \
      automake \
      make \
      python36u \
   && npm install -g typescript ts-node aws-cdk \
   && curl -O https://bootstrap.pypa.io/get-pip.py \
   && python3.6 get-pip.py \
   && pip install awscli

COPY --from=fogfish/erlang-centos /usr/local/otp /usr/local/otp
ENV PATH /usr/local/otp/bin:$PATH

ENTRYPOINT [ "/usr/local/bin/config.sh" ]
