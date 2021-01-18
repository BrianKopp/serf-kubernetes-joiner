#!/bin/bash

# set up sigterm handling
_term() {
    DIDTERM=1
    echo "caught signal"
}

trap _term SIGTERM
trap _term SIGINT
trap _term SIGKILL

echo "running serf discovery reporter"
DIDTERM=0
while [ $DIDTERM -eq 0 ]; do
    NOW=$(date +%s)
    THEN=$(($NOW+600))
    ITEM="{\"ip\": { \"S\": \"$MY_IP\" }, \"ttl\": { \"N\": \"$THEN\" }}"
    echo "setting self in dynamo as IP $MY_IP and item $ITEM"
    aws dynamodb put-item \
        --table-name $TABLE_NAME \
        --return-values NONE \
        --item "$ITEM"
    echo "sleeping 30s..."
    sleep 30
done

echo "shutting down serf discovery reporter"
