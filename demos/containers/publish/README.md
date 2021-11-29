# Make your images available outside your local machine

## Prerequisites

In the ["funny-server" demo](../funny-server/) we used `docker build` to create the image `funny-server:1.0.0`, which is still present on the local machine.

## External registry

Decide where you want to publish your image to, e.g. pick an "OCI registry" service. In this example we are using an an instance of an "Azure Container Registry" called _"combikubecourse.azurecr.io"_.

## Login

Usually access to registries is restricted, at least when it comes to _pushing_ images to it. So, to authenticate with the registry service, you first do a "login"

```shell
docker login -u <username> combikubecourse.azurecr.io
```

> ***Variants***
>
> There are variants of the syntax that lets you provide the password without interaction, which is useful for automation, e.g. in a "build pipeline"

## (Re-)Tag and push

The "push" command doesn't take a destination as a separate argument. Instead it derives it from the image name. Therefore you must "re-tag" the image:

```shell
docker tag funny-server:1.0.0 combikubecourse.azurecr.io/<namespace>/funny-server:1.0.0
```

> ***Namespace***
>
> In the context of OCI images, you can consider "namespaces" to just be a prefix string in the image name, e.g. "demo" or "demo/test".
>
> The registry service will typically implement access restrictions which allow specific users permissions for certain namespace patterns.

Now, push the image:

```shell
docker push combikubecourse.azurecr.io/<namespace>/funny-server:1.0.0
```

## Did it work?

There are multiple ways to confirm that the image is now available in the remote registry service.

### Pull it

Remove the local tag (to avoid a cache hit) and pull it

```shell
docker image rm combikubecourse.azurecr.io/<namespace>/funny-server:1.0.0
docker pull combikubecourse.azurecr.io/<namespace>/funny-server:1.0.0
```

### Browse via `oras` CLI

The `oras` project includes both CLI tools and packages (for different languages) to interact with OCI registries. See <https://github.com/oras-project/oras> for details.

```shell
oras repo ls combikubecourse.azurecr.io/<namespace>
oras repo tags combikubecourse.azurecr.io/<namespace>/funny-server
```

> ***Credentials?***
>
> The `oras` CLI will piggyback on the `docker login` configuration, so you don't have to login explicitly (but you can)

### Run a "Web GUI" browser

If you want a richer (GUI) experience than `oras` gives you, there are options for running a web-based application locally via Docker (surprised?).

This is one such example:

```shell
docker run --rm -e DOCKER_REGISTRY_URL=https://combikubecourse.azurecr.io -e=SECRET_KEY_BASE=$(openssl rand -hex 64) --name registry-browser -p 127.0.0.1:8080:8080 klausmeyer/docker-registry-browser
```
