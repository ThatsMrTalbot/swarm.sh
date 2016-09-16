#!/bin/sh

if [ $# -eq 0 ]; then
    echo "Specify a host to ssh onto [swarm-master|swarm-slave1|swarm-slave2|swarm-slave3]"
    exit 1
fi

docker exec -it $1 //bin/sh