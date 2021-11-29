# Multistage builds for a containerized C++/CMake app 

The [Dockerfile](./Dockerfile) shows the basic principles of encapsulating specific build/run instructions, as described in the [application's README](./app/README.md), into a language/stack invariant container image.

The _other_ Dockerfiles (with `.multi.` suffixes) are examples of how to leverage multistage builds to reduce the resulting image size.

> Quick glance at the app's [README](./app/README.md) and the [c++ code](./app/main.cpp).
>
> * Note the "g++" and "cmake" _build_ dependencies

## Basic vs "multi.ubuntu"

```shell
diff --color -y Dockerfile Dockerfile.multi.ubuntu
```

```shell
docker build -t cpp-example:basic -f Dockerfile .
docker build -t cpp-example:multi.ubuntu -f Dockerfile.multi.ubuntu .
docker image ls --filter=reference='cpp-example'
```

```shell
docker run --name cpp --rm -it cpp-example:basic
docker run --name cpp --name cpp --rm -it cpp-example:multi.ubuntu
```

## Scratch everything

```shell
diff --color -y Dockerfile.multi.ubuntu Dockerfile.multi.scratch.1
```

> 👉 [`scratch`](https://hub.docker.com/_/scratch) "image"

```shell
docker build -t cpp-example:multi.scratch -f Dockerfile.multi.scratch.1 .
docker image ls --filter=reference='cpp-example'
```

> ***But wait...***
>
> This doesn't work!

```shell
docker run --name cpp --rm -it cpp-example:multi.scratch
```

(Shared libraries missing!)

```shell
diff --color -y Dockerfile.multi.ubuntu Dockerfile.multi.scratch.2
```

```shell
docker build -t cpp-example:multi.scratch -f Dockerfile.multi.scratch.2 .
docker image ls --filter=reference='cpp-example'
docker run --name cpp --rm -it cpp-example:multi.scratch
```

```shell
docker exec -it cpp sh
```

(Only our executable - not so easy to debug things!)

## Smaller base image (but still some useful things)

```shell
diff --color -y Dockerfile.multi.scratch.2 Dockerfile.multi.busybox
```

```shell
docker build -t cpp-example:multi.busybox -f Dockerfile.multi.busybox .
docker image ls --filter=reference='cpp-example'
```

```shell
docker run --name cpp --rm -it cpp-example:multi.busybox
```

***In parallel***

```shell
docker exec -it cpp sh
```

## ["Distroless"](https://github.com/GoogleContainerTools/distroless) images

Alternative to "scratch" - still no shells and such but with

* proper user management
* CA certificates
* timezone info
* ...

```shell
diff --color -y Dockerfile Dockerfile.multi.distroless
```

```shell
docker build -t cpp-example:multi.distroless -f Dockerfile.multi.distroless .
docker image ls --filter=reference='cpp-example'
```

Variants exists for specific languages and frameworks, e.g. C/C++

```shell
diff --color -y Dockerfile Dockerfile.multi.distroless-cc
```

(No need to do the static linking tweak)

```shell
docker build -t cpp-example:multi.distroless-cc -f Dockerfile.multi.distroless-cc .
docker image ls --filter=reference='cpp-example'
```