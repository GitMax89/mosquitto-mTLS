#!/bin/bash

docker build -t mosquitto-alpine:1.0 .
docker run --name mosquitto-tls -v /home/parallels/docker/mosquitto-alpine/data:/etc/mosquitto/data -p 8883:8883 -p 1883:1883 -it -d mosquitto-alpine:1.0
