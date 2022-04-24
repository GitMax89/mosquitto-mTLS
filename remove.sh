#!/bin/bash

docker stop mosquitto-tls
docker rm mosquitto-tls
docker rmi $(docker images | grep mosquitto-alpine | awk '{print $3}')
