#!/bin/sh

echo "pulling visualizer image"
docker exec swarm-master docker run -d -p 3000:3000 -e HOST=localhost -e PORT=3000 -v //var/run/docker.sock://var/run/docker.sock manomarks/visualizer > /dev/null 2> /dev/null && echo "visualizer started"