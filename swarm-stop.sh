#!/bin/bash

docker kill swarm-master > /dev/null 2> /dev/null && echo "swarm-master removed"
docker kill swarm-slave1 > /dev/null 2> /dev/null && echo "swarm-slave1 removed"
docker kill swarm-slave2 > /dev/null 2> /dev/null && echo "swarm-slave2 removed"
docker kill swarm-slave3 > /dev/null 2> /dev/null && echo "swarm-slave3 removed"

docker rm swarm-master > /dev/null 2> /dev/null
docker rm swarm-slave1 > /dev/null 2> /dev/null
docker rm swarm-slave2 > /dev/null 2> /dev/null
docker rm swarm-slave3 > /dev/null 2> /dev/null