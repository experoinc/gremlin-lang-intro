#!/usr/bin/env bash
echo "GREMLIN_YAML is set to: $GREMLIN_YAML"

echo "Starting Gremlin Server"
/etc/init.d/gremlin-server start
sleep 5
cat $GREMLIN_SERVER_PATH/logs/gremlin.log
sleep 0.5

echo "Starting Gremlin Console"
bin/gremlin.sh -i conf/init.groovy
