#!/bin/bash
DIGITALOCEAN_ACCESS_TOKEN=$(cat ~/digitalocean_token)

docker-machine create --driver digitalocean --digitalocean-access-token=${DIGITALOCEAN_ACCESS_TOKEN} --digitalocean-image debian-8-x64 server1
docker-machine create --driver digitalocean --digitalocean-access-token=${DIGITALOCEAN_ACCESS_TOKEN} --digitalocean-image debian-8-x64 server2
docker-machine create --driver digitalocean --digitalocean-access-token=${DIGITALOCEAN_ACCESS_TOKEN} --digitalocean-image debian-8-x64 server3

exit 0
