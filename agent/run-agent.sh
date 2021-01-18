#!/bin/bash

echo "advertising host $SELF_IP"

# Run serf agent, advertising to other members this IP,
# and listening for shell requests on 0.0.0.0 (do not do this in an untrusted network)
exec /usr/local/bin/serf agent -config-dir /usr/local/etc/serf -advertise $SELF_IP -rpc-addr 0.0.0.0:7373
