<!-- markdownlint-disable MD013 -->
# RabbitMQ Consumer

The goal of this exercise is to package a simple Python application and run it.
It will be a consumer, which reads messages from a queue in RabbitMQ which are produced by the producer in exercise 1.

1. Package `consumer.py` with Python 3.12
    * Include `consumer.conf`
    * Install python dependencies
    * Build the image with tag `consumer:1`
2. Start consumer container alongside the producer
    * Set environment variables
    * Connect it to the `coursenet` network
3. Watch `STDOUT` from the consumer container. *Set environment variable `PYTHONUNBUFFERED=1` to make it continuously write to STDOUT*.

## Run

This is a good way to start the application:

```console
pip install -r requirements.txt
PYTHONUNBUFFERED=1 RABBITMQ_USERNAME=guest RABBITMQ_PASSWORD=guest python3 -m consumer
```

Note the `PYTHONUNBUFFERED=1`, which makes sure the Python program will flush its output buffer when running in a container.

## Configurations

Valid and relevant environment variables:

| Variable name       | Default value             |
|---------------------|---------------------------|
| `CONFIG_PATH`       | `.` (current working dir) |
| `CONFIG_FILE`       | `consumer.conf `          |
| `RABBITMQ_USERNAME` |                           |
| `RABBITMQ_PASSWORD` |                           |
| `RABBITMQ_URL`      | `localhost`               |

Check the code ("consumer.py") and "consumer.conf" for additional details and defaults!

There are also some variables you can ignore for now (will be used in the next exercise):

| Variable name     | Default value            |
|-------------------|--------------------------|
| `INFLUXDB_ENABLE` | `false`                  |
| `INFLUXDB_TOKEN`  | `tokenStringForInfluxDB` |
| `INFLUXDB_URL`    | `localhost`              |
