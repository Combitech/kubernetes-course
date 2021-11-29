# Container (and image) basics

* How are container images defined?
* How are containers run and what's it like inside them?
* What about all the hashes and caches?

## Prerequisites - the "app"

Sources files, including "code"

> ```shell
> tree src
> ```

> ```shell
> bat src/demo-app.sh
> ```

> ```shell
> src/demo-app.sh
> ls /content
> ITERATION_DELAY=1 src/demo-app.sh
> export ITERATION_DELAY=2
> env | grep DELAY
> src/demo-app.sh
> ```

## 1. Define and build an _image_

Sequence of steps to define the content and (default) execution according to the "Dockerfile" format.

> See `Containerfile.v1`

## 2. Build and "tag"

```shell
docker build -t files-and-dirs:1 -f Containerfile.v1 .
docker image ls
```

> Note the ending `.`, i.e. the build context

## 3. Simple run

```shell
docker run files-and-dirs:1
```

> Note:
>
> * hostname
> * user and group id
> * /content

### In parallel: Inspect

```shell
docker container ls
docker ps
```

> Possible to _name_ containers explicitly when/if desired

```shell
docker logs ID/NAME
docker exec -it ID/NAME bash
ls -al /
ps -aux
echo "hello from inside" > /content/HELLO.txt
```

Outside the container

```shell
tree src
ls -l /
ps aux
```

> Isolation:
>
> * File system
> * Processes


## 4. Stop/restart container

```shell
docker stop ID/NAME
docker ps
docker ps --all
```

```shell
docker start ID/NAME --attach
```

### In parallel: Inspect

```shell
docker ps
docker logs ID/NAME
```

> Note that `HELLO.txt` still exists

## 5. Kill and cleanup

```shell
docker kill ID/NAME
docker rm ID/NAME
docker ps --all
```

> Big sweep with `docker container prune`

## 6. Run again (with alternatives)

Many arguments/options to `docker run`. Which to use depends on use case and application, e.g. background service or CLI tool.

```shell
docker run -it --rm files-and-dirs:1
```

> Also possible to run "detached" in the background (nothing on shell's stdout/stderr)

### In parallel: Inspect

```shell
docker ps
```

> This is a _new_ container name - without `HELLO.txt`

Container content is lost when the _container_ is deleted. Changes to it's filesystem are (by default) not persistent.

Exit (and remove) container via `Ctrl-C`

## 7. Iterate - update/rebuild

Edit `demo-app.sh`: `"---"` -> `"==="`

```shell
docker run -it --rm files-and-dirs:1
```

> Still `---`

```shell
docker build -t files-and-dirs:1 -f Containerfile.v1 .
```

```shell
docker image ls
```

```shell
docker run -it --rm files-and-dirs:1
```

> A _new_ image but most build steps were _cached_. From where?

## 8. "Modifying" steps (beyond `COPY`)

> See `Containerfile.v2`
>
> ```shell
> bat Containerfile.v*
> ```

```shell
docker build -t files-and-dirs:2 -f Containerfile.v2 .
docker run -it --rm files-and-dirs:2
```

> Result of new step (`buildlog.txt`) is part of the image and `dir_a/file_a1.txt` is _not_.

### Caching (good or bad?)

Build again (without any changes)

```shell
docker build -t files-and-dirs:2 -f Containerfile.v2 .
```

> `RUN` command was cached (but was that what we wanted?)

## 9. Not really "immutable"

You _can_ tweak the environment as well as the file system for a new container without rebuilding an image

```shell
mkdir extra-content
echo "More content" > extra-content/more.txt
docker run -it --rm -e=ITERATION_DELAY=4 -v ./extra-content:/content/extra files-and-dirs:2
```

> Different delay and `more.txt` now part of container's filesystem via "mounted volume"

### In parallel: Write to mounted volume

```shell
docker ps
docker exec ID/NAME bash -c 'echo "hello" > /content/extra/$(hostname).txt'
```

### Stop and start again (new container)

```shell
docker run -it --rm -e=ITERATION_DELAY=4 -v ./extra-content:/content/extra files-and-dirs:2
```

> Persist data between container instances!
>
> ```shell
> tree extra-content
> ```


## 10. What (exactly) is an image?

> See `Containerfile.v2`

> _(side note)_
>
> ```shell
> sudo ls -l /var/lib/docker/image/overlay2/imagedb/content/sha256
> sudo ls -l /var/lib/docker/image/overlay2/layerdb/sha256
> ```

Image format defined as part of the "OCI specification"

```shell
cd ~/temp/ &&  rm -rf *
docker image save files-and-dirs:2 -o image.tar
tar -xf image.tar && rm image.tar
ls -l
jq . manifest.json
```

> 6 _ordered_ layers, suspiciously similar to the number of _fs-modifying_ steps. One of the layers is huge.

## Extract and inspect

```shell
mkdir l1 l2 l3 l4 l5 l6
tar -xf LAYERFILE -C l1
 :

tree -a l1 | less
tree -a l2
tree -a l3
tree -a l4
tree -a l5
tree -a l6
```

> "Deletions" are just additions using "white-out files" - cannot hide anything secret
