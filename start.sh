#!/usr/bin/env bash
echo "Starting Gremlin Server"
/etc/init.d/gremlin-server start
sleep 5
cat /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/logs/gremlin.log
sleep 0.5

echo "Starting Gremlin Console"
bin/gremlin.sh -i conf/init.groovy
