#!/bin/bash -e

echo "checking $SERF_HOST on port $SERF_PORT to see who the members are..."

while true; do
    echo "fetching the current members list"
    serf members -rpc-addr "$SERF_HOST:$SERF_PORT"
    echo "sleeping 5s..."
    sleep 5
done