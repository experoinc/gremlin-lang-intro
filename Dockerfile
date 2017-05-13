# FROM alpine:latest
FROM frolvlad/alpine-glibc:latest
MAINTAINER Josh Perryman <josh@experoinc.com>

LABEL Description="TinkerPop 3.3-SNAPSHOT Gremlin Server and Gremlin Console"

# Install Anaconda Python 3
####
ENV PATH=/opt/conda/bin:$PATH \
    ANACONDA=Anaconda3-4.3.1-Linux-x86_64.sh
    
RUN apk add --no-cache --virtual=build-deps --update-cache \
    wget bash \
    && wget -q --no-check-certificate https://repo.continuum.io/archive/$ANACONDA \
    && /bin/bash $ANACONDA -b -p /opt/conda \
    && rm -rf /root/.continuum /opt/conda/pkgs/* \
    && rm $ANACONDA  \
    && apk del build-deps

RUN pip install gremlinclient && pip install goblin

ENV PATH /opt/conda/bin:$PATH


COPY apache-tinkerpop-gremlin-console.zip /home/
COPY apache-tinkerpop-gremlin-server.zip /home/

# Install TinkerPop's Gremlin Console & Gremlin Server
####
# Need coreutils & procps b/c Alpine Linux uses busybox for more command line options and that's sometime lame (or at least incompatible with some scripts)
# coreutils required b/c gremlin-console uses 'paste'
# procps required b/c gremlin-server uses 'ps' switches not supported by busybox
# Install gremlin-server service and start
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk --update add bash coreutils procps openjdk8-jre-base unzip openrc \
    && unzip -q home/apache-tinkerpop-gremlin-console.zip -d /opt \
    && unzip -q home/apache-tinkerpop-gremlin-server.zip -d /opt \
    && rm home/apache-tinkerpop-gremlin-console.zip \
    && rm home/apache-tinkerpop-gremlin-server.zip \
    && ln -s /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/bin/gremlin-server.sh /etc/init.d/gremlin-server \
    && rc-update add gremlin-server \
    && apk del unzip openrc \
    && rm -rf /var/cache/apk/*

# Add data files to the Gremlin Server data directory
COPY citations.kryo /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/data/

# Add start-up scripts to the Gremlin Server scripts directory
COPY generate-citations.groovy /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/scripts/
COPY generate-all.groovy /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/scripts/

# Add the YAML files to the Gremlin Server conf directory
COPY gremlin-server-citations.yaml /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/conf/
COPY gremlin-server-all.yaml /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/conf/


# The GREMLIN_YAML variable is used to specify which YAML file is used to configure the Gremlin Server
# This image includes two options, one that only loads the Citations data set, and a second which loads all sample data as well as the Citations data set
# ENV GREMLIN_YAML $GREMLIN_HOME/conf/gremlin-server-citations.yaml
ENV GREMLIN_YAML $GREMLIN_HOME/conf/gremlin-server-all.yaml

# set gremlin-console init script start in console
COPY init.groovy /opt/apache-tinkerpop-gremlin-console-3.3.0-SNAPSHOT/conf/
COPY start.sh /opt/apache-tinkerpop-gremlin-console-3.3.0-SNAPSHOT
COPY start.ipynb /opt/apache-tinkerpop-gremlin-console-3.3.0-SNAPSHOT

# Set starting directory and start the start.sh script
# See the FAQ section in the README.md for why I use a start script
WORKDIR /opt/apache-tinkerpop-gremlin-console-3.3.0-SNAPSHOT
# ENTRYPOINT /bin/bash ./start.sh

#ENTRYPOINT [ "/usr/bin/tini", "--" ]
# CMD [ "/bin/bash" ]
# CMD ["/bin/sh", "-c", "jupyter notebook --port=8888 --ip=0.0.0.0"]
ENTRYPOINT /bin/bash ./start.sh
