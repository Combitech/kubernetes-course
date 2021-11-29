<!-- markdownlint-disable MD013 -->
# RabbitMQ Producer

This application will publish samples from a signal and publish the values as
messages on a RabbitMQ message broker.

1. Create a Containerfile, build it and tag it `producer:1`
2. Create a network called `coursenet`
3. Start RabbitMQ container
    * Use latest image with management plugin from Docker Hub
    * Connect it to the `coursenet` network and publish port `15672` to your host
    * Name the RabbitMQ container `messagebus`
4. Start the producer container with appropriate settings
5. Login to RabbitMQ management portal (http://localhost:15672) and verify that messages are delivered properly
    * Username and Password are both `guest`
    * Check the message rate of the exchange you use

## Build

To build the program, use Golang 1.22 and run `go build` to compile.

## Run

This is one way to start the application:

```console
SIGNAL_TYPE=sine RABBITMQ_HOST=messagebus RABBITMQ_USERNAME=guest RABBITMQ_PASSWORD=guest go run main.go
```

## Configurations

Valid signal types:

* line
* sine
* square
* zero

Valid environment variables:

| Variable name            | Default value |
|--------------------------|---------------|
| `SIGNAL_SAMPLE_INTERVAL` | `1`           |
| `SIGNAL_TYPE`            | `zero`        |
| `SIGNAL_A`               | `1.0`         |
| `SIGNAL_B`               | `1.0`         |
| `RABBITMQ_EXCHANGE`      | `signal`      |
| `RABBITMQ_USERNAME`      |               |
| `RABBITMQ_PASSWORD`      |               |
| `RABBITMQ_HOST`          |               |
| `SENDER_ID`              |               |
| `RABBITMQ_VHOST`         |               |
| `RABBITMQ_TOPIC`         |               |

Check the code ("main.go") for details!
