<!-- markdownlint-disable MD013 -->
# RabbitMQ Consumer

The goal of this exercise is to package a simple Python application and run it.
It will be a consumer, which reads messages from a queue in RabbitMQ which are produced by the producer in exercise 1.

1. Package `consumer.py` with Python 3.8
    * Include `consumer.conf`
    * Build & push image to the `myregistry` registry
2. Start consumer container alongside the producer
    * Set environment variables
    * Connect it to the `coursenet` network
3. Watch `STDOUT` from the consumer container

## Run

This is a good way to start the application:

```console
PYTHONUNBUFFERED=1 RABBITMQ_USERNAME=guest RABBITMQ_PASSWORD=guest python3 -m consumer
```

Note the `PYTHONUNBUFFERED=1`, which makes sure the Python program will flush its output buffer when running in a container.

## Configurations

Valid Environment Variables:

* `RABBITMQ_USERNAME`
* `RABBITMQ_PASSWORD`
* `RABBITMQ_URL`
* `INFLUXDB_ENABLE`
* `INFLUXDB_TOKEN`
* `INFLUXDB_URL` (check the Service name)
* `CONFIG_PATH`
