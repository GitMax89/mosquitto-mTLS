FROM alpine

MAINTAINER   Massimiliano Tavernese <m.tavernese@reply.it>

RUN apk update && apk upgrade
RUN apk add openrc --no-cache
RUN mkdir -p /etc/mosquitto/config && \
    mkdir -p /etc/mosquitto/data && \ 
    mkdir -p /etc/mosquitto/certs

ADD mosquitto.conf /etc/mosquitto/config/mosquitto.conf
ADD /cert/ca-crt.pem /etc/mosquitto/certs/ca-crt.pem
ADD /cert/server-crt.pem /etc/mosquitto/certs/server-crt.pem
ADD /cert/server-key.pem /etc/mosquitto/certs/server-key.pem
ADD mosquitto.passwd /etc/mosquitto/config/mosquitto.passwd

RUN apk add --upgrade mosquitto && rc-update add mosquitto boot && \
    touch /etc/mosquitto/config/mosquitto.passwd && \
    mosquitto_passwd -b /etc/mosquitto/config/mosquitto.passwd mosquitto 123456 && \
    chown -R mosquitto:mosquitto /etc/mosquitto && \
    chmod 755 /etc/mosquitto/certs/*

EXPOSE 8883
CMD ["mosquitto", "-c", "/etc/mosquitto/config/mosquitto.conf"]
