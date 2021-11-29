# Interact with containerized services

The [Containerfile.server](./Containerfile.server) shows the basic principles of hosting a Python web application inside a container.

See [app.py](./app/app.py) for info on ENV variables to control the app's behavior.

> _See the [application's README](./app/README.md) for details on how to run the application locally (without containers)._

## "Official images"

Curated set of Docker open source and drop-in solution repositories.

👉 https://hub.docker.com/_/python/tags?page=1&name=3.11

> See [Containerfile.server](./Containerfile.server)
>
> Basically follow the instructions for how to run locally (good for now, let's revise that later in the course)

## Build the container image

```shell
docker build -t funny-server:1.0.0 -f Containerfile.server .
docker image ls # list all images on host
```

## Serve via loopback (localhost) - not very useful

```shell
docker run -it --rm --name=funny-server funny-server:1.0.0
```

Running `curl localhost:8080` on the host doesn't work.

But `docker exec -it funny-server sh` into container and then `wget localhost:8080 -q -O -` is fine.

> "localhost" _inside_ the container is not the host's "localhost"

## Serve via container's network interface - but not on the host

```shell
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 funny-server:1.0.0
```

Running `curl localhost:8080` on the host still doesn't work.

Get IP address of container (and a lot more!)

```shell
docker inspect funny-server
```

Target container's IP address explicitly

```shell
curl -s IP-address:8080
```

## Publish port to the host

👉 https://docs.docker.com/network/#published-ports

### Variants

```shell
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 -p 8080:8080 funny-server:1.0.0
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 -p 127.0.0.1:8080:8080 funny-server:1.0.0
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 -p 127.0.0.1:18080:8080 funny-server:1.0.0
```

### Optional hints to users

👉 https://docs.docker.com/engine/reference/builder/#expose

> See [Containerfile.server.explicit](./Containerfile.explicit.server)

## Interaction between containers

### Add a "web client" into the mix.

> See [Container.client](./Containerfile.client)

```shell
docker build -t client:1.0.0 -f Containerfile.client .
docker run -it --rm client:1.0.0
```

> Note what `ENTRYPOINT` and `CMD` accomplishes together
>
> ```shell
> docker run -it --rm client:1.0.0 -version
> ```

```shell
docker run -it --rm client:1.0.0 example.com
```

Target funny-server's container's IP address explicitly

```shell
docker run -it --rm client:1.0.0 http://<ip-address>:8080
```

### Use dedicated network

```shell
docker network create my-net
```

Run both server and client containers connected to the dedicated network.

> Also give the containers deterministic names: `funny-server` and `client`

```shell
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 --network=my-net funny-server:1.0.0
```

```shell
docker run -it --rm --name=client --network=my-net client:1.0.0 example.com
```

Check which IP addresses each container got:

```shell
docker inspect client | tail -20
docker inspect funny-server | tail -20
```

> Side-note: `inspect` command works on many resources types, e.g. images, containers and networks

Use the [_w3m_ web-client](https://w3m.sourceforge.net/MANUAL) to navigate (`U` command) to the server: 

* Via IP address: http://172.18.0.2:8080 (example IP address)
* Via _name_: http://funny-server:8080

> Docker provides DNS resolving for the dedicated network 

### Mix dedicated network and publishing

Shut down the server (`Ctrl + C`) and start it again with `-p` added to the server's `run` command:

```shell
docker run -it --rm --name=funny-server -e=SERVER_HOST=0.0.0.0 --network=my-net -p 127.0.0.1:8080:8080 funny-server:1.0.0
```

> Allows for interacting containers while also using the host's web-browser for access the "system".
