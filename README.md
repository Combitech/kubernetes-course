<!-- markdownlint-disable MD013 -->
# Welcome

Great that you found your way here!

In this guide, you will find the prerequisites for the Kubernetes course. It is important that you have completed them before the course so any troubles can be found and resolved on beforehand.

Do not feel intimidated if you do not understand exactly what each command here does. The steps pointed out are just to make sure everything is setup properly so you can follow along during the course! :-)

## Day 1: Confirm that necessary tools are installed

During the course, you will typically use a dedicated lab computer, running Linux (Ubuntu 24.04).

The computer has been prepared in advance with all necessary tools installed. To confirm this you should run the following commands and ensure that there are no error indications.

```shell
docker version
```

```shell
kubectl version --client
```

```shell
helm version
```

```shell
k3d --version
```

> ***No course computer?***
>
> If you have to (or for some reason really want to) use your own computer, details around installation of tools can be found in the following guides:
>
> * [Getting started with WSL2](./wsl2-getting-started.md) (if you're running Windows)
> * [Install dependencies](./installing-dependencies.md)

## Day 2: Setup a Kubernetes cluster

You will be using [`k3d`](https://k3d.io/) to setup a local Kubernetes cluster on your machine. `k3d` is a lightweight wrapper around the minimal Kubernetes distribution called `k3s`.

The following command will create a cluster named "primer".

```shell
k3d cluster create --api-port 127.0.0.1:6443 --image rancher/k3s:v1.32.4-k3s1 primer --registry-create myregistry:127.0.0.1:1234
```

The command above also creates a local "image registry" `myregistry`. You will probably _not_ use this during the course but it may server as a "Plan B" if there are network connectivity issues. 

> ***Using your own computer?***
>
> If `KUBECONFIG` is set in your environment, you also need to run this:
>
> ```shell
> k3d kubeconfig merge primer
> export KUBECONFIG="~/.k3d/kubeconfig-primer.yaml:${KUBECONFIG}"
> ```

## Check Kubernetes access

Assuming the previous steps were successful, you should now be able to connect to the Kubernetes cluster using `kubectl`:

```console
$ kubectl config use-context k3d-primer
Switched to context "k3d-primer".
```

```console
$ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:6443
CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

Also check that the Kubernetes version of your client matches the one on the server:

```console
$ kubectl version
Client Version: v1.32.4
Kustomize Version: v5.5.0
Server Version: v1.32.4+k3s1
```

It is OK if the "patch" version (_z_ in _x_._y_.z) differs.
