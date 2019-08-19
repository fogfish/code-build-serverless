FROM centos

##
## config docker and docker-in-docker
RUN set -e \
	&& curl -fsSL get.docker.com -o get-docker.sh \
	&& sh get-docker.sh \
	&& curl -o /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/master/hack/dind"  \
	&& chmod +x /usr/local/bin/dind

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
