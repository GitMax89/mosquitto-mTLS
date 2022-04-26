#!/bin/bash

docker stop mosquitto-ssl
docker rm mosquitto-ssl
docker rmi $(docker images | grep eclipse.*1.6.15-openssl | awk '{print $3}')
