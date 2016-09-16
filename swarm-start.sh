#!/bin/bash

docker run $@ -h swarm-master -p 3000:3000 --privileged --name=swarm-master --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run -h swarm-slave1 --privileged --name=swarm-slave1 --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run -h swarm-slave2 --privileged --name=swarm-slave2 --rm docker:1.12-dind > /dev/null 2> /dev/null  &
docker run -h swarm-slave3 --privileged --name=swarm-slave3 --rm docker:1.12-dind > /dev/null 2> /dev/null &

sleep 1

docker exec swarm-master docker swarm init > /dev/null 2> /dev/null && echo "swarm-master initialized"

TOKEN=`docker exec swarm-master docker swarm join-token worker -q`
IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' swarm-master`

docker exec swarm-slave1 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave1 joined"
docker exec swarm-slave2 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave2 joined"
docker exec swarm-slave3 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave2 joined"

echo "pulling visualizer image"
docker exec swarm-master docker run -d -p 3000:3000 -e HOST=localhost -e PORT=3000 -v /var/run/docker.sock:/var/run/docker.sock manomarks/visualizer > /dev/null 2> /dev/null && echo "visualizer started"