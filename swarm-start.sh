#!/bin/sh

set -e

echo "pulling registry"
docker pull thatsmrtalbot/docker-registry-proxy > /dev/null 2> /dev/null

echo "starting registry"

docker run -d -h registry --name registry -v "//opt/shared/docker_registry_cache://var/lib/registry" thatsmrtalbot/docker-registry-proxy  > /dev/null 2> /dev/null
REGISTRY_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' registry`

sleep 1

echo "starting nodes"

DAEMON_COMMANDS="daemon --registry-mirror http://$REGISTRY_IP:5000 --insecure-registry $REGISTRY_IP:5000 --host unix:///var/run/docker.sock --host tcp://0.0.0.0:2375 --storage-driver vfs"

docker run -h swarm-master -p 3000:3000 --privileged --name=swarm-master --rm --entrypoint docker $@ docker:1.12-dind $DAEMON_COMMANDS > /dev/null 2> /dev/null  &
docker run -h swarm-slave1 --privileged --name=swarm-slave1 --rm --entrypoint docker docker:1.12-dind $DAEMON_COMMANDS > /dev/null 2> /dev/null  &
docker run -h swarm-slave2 --privileged --name=swarm-slave2 --rm --entrypoint docker docker:1.12-dind $DAEMON_COMMANDS > /dev/null 2> /dev/null  &
docker run -h swarm-slave3 --privileged --name=swarm-slave3 --rm --entrypoint docker docker:1.12-dind $DAEMON_COMMANDS > /dev/null 2> /dev/null &

sleep 1

docker exec swarm-master docker swarm init > /dev/null 2> /dev/null && echo "swarm-master initialized"

TOKEN=`docker exec swarm-master docker swarm join-token worker -q`
IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' swarm-master`

docker exec swarm-slave1 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave1 joined"
docker exec swarm-slave2 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave2 joined"
docker exec swarm-slave3 docker swarm join --token $TOKEN $IP:2377 > /dev/null 2> /dev/null && echo "swarm-slave2 joined"