# Mosquitto

Very nice IOT messaging protocol.

### How to publish and subscribe to mqtt messages:

#### Publish

`mosquitto_pub -h <host-ip> -p <host-port> -u <username> -P <password> -t <topic> -m '<message>'`

#### Subscribe

`mosquitto_sub -h <host-ip> -p <host-port> -u <username> -P <password> -t <topic>`
