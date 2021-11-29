<!-- markdownlint-disable MD013 -->
# Exercise 3 Kubernetes

Deploying Kubernetes manifests.

> ❗ **NOTE:** While we pushed to `localhost`, we must use `primer` in the manifests since we’re inside the cluster now!
>
> _Example:_
> 
> `$ podman push --tls-verify=false localhost:1234/consumer:1`
> 
> -> `image: primer:1234/consumer:1`

0. Follow the instructions in Setup below
1. Create manifests for the Producer
    * Pod or Deployment
    * `Secret` for sensitive information (username/password)
2. Create manifests for Consumer
    * Pod or Deployment
    * `ConfigMap` for configuration
    * `Secret` for sensitive information (username/password)

> Tip: Use an alias for kubectl!

```console
alias k="kubectl"
k -n primer get all
```

## Setup

Before the exercise, make sure to deploy the required dependencies using Helm:

```console
helm dep build ./dependencies
helm -n primer install --create-namespace exercise ./dependencies
```

Instructions for the Helm chart are available in the chart notes:

```console
helm get notes exercise -n primer
```

