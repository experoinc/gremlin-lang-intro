FROM alpine:latest
MAINTAINER Josh Perryman <josh@experoinc.com>

LABEL Description="TinkerPop Gremlin Server and Gremlin Console"

# This Dockerfile only supports Apache TinkerPop 3.3.0 or higher
ENV APACHE_DOWNLOAD_URL http://mirrors.ibiblio.org
ENV TINKERPOP_VERSION 3.3.1
ENV GREMLIN_SERVER_PATH /opt/apache-tinkerpop-gremlin-server-$TINKERPOP_VERSION
ENV GREMLIN_CONSOLE_PATH /opt/apache-tinkerpop-gremlin-console-$TINKERPOP_VERSION

# Download TinkerPop binaries
ADD $APACHE_DOWNLOAD_URL/apache/tinkerpop/$TINKERPOP_VERSION/apache-tinkerpop-gremlin-console-$TINKERPOP_VERSION-bin.zip /home/
ADD $APACHE_DOWNLOAD_URL/apache/tinkerpop/$TINKERPOP_VERSION/apache-tinkerpop-gremlin-server-$TINKERPOP_VERSION-bin.zip /home/

# Alternatively, Apache TinkerPop zip files can be downloaded to the local directory
# COPY apache-tinkerpop-gremlin-console-$TINKERPOP_VERSION-bin.zip /home/
# COPY apache-tinkerpop-gremlin-server-$TINKERPOP_VERSION-bin.zip /home/

# Install TinkerPop's Gremlin Console & Gremlin Server
# Need coreutils & procps b/c Alpine Linux uses busybox for more command line options and that's sometime lame (or at least incompatible with some scripts)
# coreutils required b/c gremlin-console uses 'paste'
# procps required b/c gremlin-server uses 'ps' switches not supported by busybox
# Install gremlin-server service and start
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk --update add bash coreutils procps openjdk8-jre-base unzip openrc \
    && unzip -q home/apache-tinkerpop-gremlin-console-$TINKERPOP_VERSION-bin.zip -d /opt \
    && unzip -q home/apache-tinkerpop-gremlin-server-$TINKERPOP_VERSION-bin.zip -d /opt \
    && rm home/apache-tinkerpop-gremlin-console-$TINKERPOP_VERSION-bin.zip \
    && rm home/apache-tinkerpop-gremlin-server-$TINKERPOP_VERSION-bin.zip \
    && ln -s $GREMLIN_SERVER_PATH/bin/gremlin-server.sh /etc/init.d/gremlin-server \
    && rc-update add gremlin-server \
    && apk del unzip openrc \
    && rm -rf /var/cache/apk/*

# Add tinkergraph config to set vertexIdManager, edgeIdManager, vertexPropertyIdManager as LONGs
# The alternative approach is to set it at start in the generate-all.groovy script
COPY tinkergraph-longids.properties $GREMLIN_SERVER_PATH/conf/

# Add data files to the Gremlin Server data directory
COPY citations.kryo $GREMLIN_SERVER_PATH/data/
COPY air-routes-small.graphml $GREMLIN_SERVER_PATH/data/
COPY air-routes.graphml $GREMLIN_SERVER_PATH/data/

# Add start-up scripts to the Gremlin Server scripts directory
COPY generate-citations.groovy $GREMLIN_SERVER_PATH/scripts/
COPY generate-aironly.groovy $GREMLIN_SERVER_PATH/scripts/
COPY generate-all.groovy $GREMLIN_SERVER_PATH/scripts/

# Add the YAML files to the Gremlin Server conf directory
COPY gremlin-server-citations.yaml $GREMLIN_SERVER_PATH/conf/
COPY gremlin-server-aironly.yaml $GREMLIN_SERVER_PATH/conf/
COPY gremlin-server-all.yaml $GREMLIN_SERVER_PATH/conf/

# The GREMLIN_YAML variable is used to specify which YAML file is used to configure the Gremlin Server
# This image includes three options:
#    gremlin-server-citations.yaml - only loads the citations data set
#    gremlin-server-aironly.yaml - only loads the air routes data set
#    gremlin-server-all.yaml -  loads all 7 data sets (citations, air routes, air routes small, and the four TinkerPop ones)
# ENV GREMLIN_YAML $GREMLIN_SERVER_PATH/conf/gremlin-server-citations.yaml
# ENV GREMLIN_YAML $GREMLIN_SERVER_PATH/conf/gremlin-server-aironly.yaml
ENV GREMLIN_YAML $GREMLIN_SERVER_PATH/conf/gremlin-server-all.yaml

# set gremlin-console init script start in console
COPY init.groovy $GREMLIN_CONSOLE_PATH/conf/
COPY start.sh $GREMLIN_CONSOLE_PATH

# Set starting directory and start the start.sh script
# See the FAQ section in the README.md for why I use a start script
WORKDIR $GREMLIN_CONSOLE_PATH
ENTRYPOINT /bin/bash ./start.sh
