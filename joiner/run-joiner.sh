#!/bin/bash

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
    echo "member list (length $MEMBER_LIST_WC):"
    echo $MEMBER_LIST
    if [ $MEMBER_LIST_WC -gt 1 ]; then
        echo "found more than one member, no need to join"
        echo "sleeping 5s..."
        sleep 5
        continue
    fi
    echo "only one member found, attempting to join other members..."
    ALL_PEER_IPS=$(aws dynamodb scan --table-name $TABLE_NAME | jq '.Items[] | .ip.S')
    echo "found peer IPs"
    echo $ALL_PEER_IPS
    for ipwithquotes in $ALL_PEER_IPS
    do
        ip=$(echo "$ipwithquotes" | sed -e 's/^"//' -e 's/"$//')
        echo "evaluating ip $ip..."
        echo "  checking connectivity to $ip on port 7946"
        nc -uz -w5 $ip 7946
        if [ "$?" -ne 0 ]; then
            echo "  failed to connect to $ip on port 7946 via udp"
            continue
        fi

        echo "  successfully connected to $ip on port 7946"

        # check if we've already joined this IP
        echo "  checking to see if already established connection to $ip..."
        SERF_NEIGHBOR_ALIVE=$(serf members -rpc-addr $SERF_HOST:$SERF_PORT | grep $ip:7946 | grep alive | wc -l)
        if [ $SERF_NEIGHBOR_ALIVE -eq 1 ]; then
            echo "  connection to $ip is already alive, moving along to another host..."
            continue
        fi

        echo "  attempting to join $ip on port 7946"
        serf join $ip -rpc-addr $SERF_HOST:$SERF_PORT
        if [ "$?" -ne 0 ]; then
            echo "  serf seems to have failed to join $ip, see if another IP has any luck..."
            continue
        fi
        echo "  serf seems to think it joined $ip, we're done!"
        break
    done

    echo "sleeping 5s..."
    sleep 5
done

echo "shutting down joiner"
