#!/bin/bash

docker run --privileged --name=swarm-master --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run --privileged --name=swarm-slave1 --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run --privileged --name=swarm-slave2 --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run --privileged --name=swarm-slave3 --rm docker:1.12-dind > /dev/null 2> /dev/null &

sleep 1

docker exec swarm-master docker swarm init

TOKEN=`docker exec swarm-master docker swarm join-token worker -q`
IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' swarm-master`

docker exec swarm-slave1 docker swarm join --token $TOKEN $IP:2377
docker exec swarm-slave2 docker swarm join --token $TOKEN $IP:2377
docker exec swarm-slave3 docker swarm join --token $TOKEN $IP:2377