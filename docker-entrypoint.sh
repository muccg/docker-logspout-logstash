#!/bin/bash

# wait for a given host:port to become available
#
# $1 host
# $2 port
function dockerwait {
    while ! exec 6<>/dev/tcp/"$1"/"$2"; do
        echo "$(date) - waiting to connect $1 $2"
        sleep 5
    done
    echo "$(date) - connected to $1 $2"
 
    exec 6>&-
    exec 6<&-
}


function wait_for_services {
     if [[ "$WAIT_FOR_LOGSTASH" ]] ; then
         dockerwait "${LOGSTASH_SERVER}" "${LOGSTASH_PORT}"
     fi
}


function defaults {
    : "${LOGSTASH_SERVER:=logstash}"
    : "${LOGSTASH_PORT:=5140}"
    : "${ROUTE_URIS:=logstash+tcp://${LOGSTASH_SERVER}:${LOGSTASH_PORT}}"

	export LOGSTASH_SERVER LOGSTASH_PORT ROUTE_URIS
}



defaults
env | sort
wait_for_services

exec /bin/logspout
