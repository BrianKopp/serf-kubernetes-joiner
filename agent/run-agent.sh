#!/bin/bash

echo "advertising host $SELF_IP"

exec /usr/local/bin/serf agent -config-dir /usr/local/etc/serf -advertise $SELF_IP
