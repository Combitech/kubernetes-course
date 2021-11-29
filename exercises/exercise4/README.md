<!-- markdownlint-disable MD013 -->
# Exercise 4 Kubernetes in the cloud

> ❗Ensure that "consumer" and "producer" images from exercise 1 and 2 have been pushed to the external registry before starting here.

Deploying Kubernetes manifests like in exercise3 but with some key differences:

* You will use an external message broker with a dedicated vhost assigned to you
  * You access the cluster via a new kubectl context/config with access token assigned to you
* You will deploy to a multi-tenant cluster in a dedicated namespace assigned to you
  * You will authenticate with special credentials assigned to you
* You must expose the Grafana service outside the cluster via an Ingress definition.

> ❗ **NOTE:** 
> 
> * You have to modify `consumer.conf`according to your assigned vhost name
> * You must also adjust some environment variables (url and credentials)

1. Follow the instructions in Setup below
2. Create manifests for the Producer
  * Deployment (but you can start with Pod if that's what you did in exercise3)
  * `Secret` for sensitive information (username/password)
3. Create manifests for Consumer
  * Deployment (but you can start with Pod if that's what you did in exercise3)
  * `ConfigMap` for configuration
  * `Secret` for sensitive information (username/password)
4. Create manifest for exposing Grafana
  * `Ingress` pointing to the Grafana `Service`
  * Without TLS (https) as a first step
  * Add TLS support via cert-manager annotations as a second step

> Tip: Use an alias for kubectl!

```console
alias k="kubectl"
k get all
```

> Tip: Often easiest to create Secrets for credentials via kubectl (without yaml). Read the [docs](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/#create-a-secret) for details.

> How to configure `ingressClassName`?
>
> Tip: `k get ingressclass`

> How to configure cert-manager?
>
> Check the [docs](https://cert-manager.io/docs/usage/ingress/) for how to extend you Ingress definition
>
> Tip: `k get clusterissuer`

## Setup

Before the exercise, make sure to deploy the required dependencies (InfluxDB and Grafana) using Helm:

```console
helm dep build ./dependencies
helm install exercise ./dependencies
```

> Remember to configure the kubectl context and target namespace first.

Instructions for the Helm chart are available in the chart notes:

```console
helm get notes exercise
```
