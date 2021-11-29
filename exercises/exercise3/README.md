<!-- markdownlint-disable MD013 -->
# Exercise 3 Kubernetes

> ❗Ensure that "consumer" and "producer" images from exercise 1 and 2 have been pushed to the external registry before starting here.

Deploying Kubernetes manifests.

> ❗ **NOTE:** New `consumer.conf` in exercise 3!

1. Follow the instructions in Setup below
2. Create manifests for the Producer
    * Pod or Deployment
    * `Secret` for sensitive information (username/password)
3. Create manifests for Consumer
    * Pod or Deployment
    * `ConfigMap` for configuration
    * `Secret` for sensitive information (username/password)

> Tip: Use an alias for kubectl!

```console
alias k="kubectl"
k get all
```

## Setup

Before the exercise:

1. Create a docker-registry `Secret` named "regcred" with _your_ assigned registry credentials
2. make sure to deploy the required dependencies (RabbitMQ, InfluxDB and Grafana) using Helm:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dep build ./dependencies
helm install exercise ./dependencies
```

Instructions for the Helm chart are available in the chart notes:

```console
helm get notes exercise
```
