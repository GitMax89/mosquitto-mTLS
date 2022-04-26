# mosquitto-mTLS

<b>install:</b>

Pull the following images from docker.io                                             
```sh
docker pull eclipse-mosquitto:1.6.15-openssl
```

Generate the certificates to be included in the folder /srv/mosquitto/certs                                             
```sh
sudo mkdir -p /srv/mosquitto/certs

# Generate a Certificate Authority (CA)
openssl req -new -x509 -days 9999 -keyout ca-key.pem -out ca-crt.pem

# Generate a Server Certificate
openssl genrsa -out server-key.pem 4096
openssl req -new -key server-key.pem -out server-csr.pem
openssl x509 -req -days 9999 -in server-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out server-crt.pem
openssl verify -CAfile ca-crt.pem server-crt.pem (if there are errors repeat the procedure)

# Generate a Client Certificate
openssl genrsa -out client1-key.pem 4096
openssl req -new -key client1-key.pem -out client1-csr.pem
openssl x509 -req -days 9999 -in client1-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out client1-crt.pem
openssl verify -CAfile ca-crt.pem client1-crt.pem (if there are errors repeat the procedure)

```

Create mosquitto.conf on /srv/mosquitto/config and insert a following line:
```sh
sudo nano /srv/mosquitto/config/mosqitto.conf

port 8883

cafile /mosquitto/config/certs/ca-crt.pem
certfile /mosquitto/config/certs/server-crt.pem
keyfile /mosquitto/config/certs/server-key.pem

require_certificate true

```

Insert a following certificate on /srv/mosquitto/certs
```sh
- ca-crt.pem
- server-crt.pem
- server-key.pem

```

run following command to create a mosquitto container:
```sh
sudo docker run --name mosquitto-ssl -v /srv/mosquitto/config:/mosquitto/config -p 8883:8883 --init -d -it  eclipse-mosquitto:1.6.15-openssl
```

Create mosquitto.passwd on /srv/mosquitto/mosquitto.passwd
```sh
docker exec -it mosquitto-ssl sh -c "touch /mosquitto/mosquitto.passwd && mosquitto_passwd -b /mosquitto/mosquitto.passwd mosquitto 123456"
```

Restart service:
```sh
docker container restart mosquitto-ssl
```

If everything is correct the created tree should look like this
```sh
./
├── certs
│   ├── ca-crt.pem
│   ├── server-crt.pem
│   └── server-key.pem
├── mosquitto.conf
└── mosquitto.passwd

```

