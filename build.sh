#!/bin/bash

docker build -t mosquitto-alpine:1.0 .
docker run --name mosquitto-tls -v /your/local/volume:/etc/mosquitto/data -p 8883:8883 -it -d mosquitto-alpine:1.0
