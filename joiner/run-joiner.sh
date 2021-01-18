#!/bin/bash -e

echo "checking $SERF_HOST on port $SERF_PORT to see who the members are..."

# set up sigterm handling
_term() {
    DIDTERM=1
    echo "caught signal"
}

trap _term SIGTERM
trap _term SIGINT
trap _term SIGKILL

echo "running joiner..."
DIDTERM=0
while [ $DIDTERM -eq 0 ]; do
    echo "fetching the current members list..."
    MEMBER_LIST=$(serf members -rpc-addr $SERF_HOST:$SERF_PORT)
    MEMBER_LIST_WC=$(echo $MEMBER_LIST | wc -l)
    if [ $MEMBER_LIST_WC -ge 1 ]; then
        echo "only one member found, attempting to join other members..."
    else
        echo "found more than one member, no need to join"
    fi
    echo "sleeping 5s..."
    sleep 5
done

echo "shutting down joiner"
