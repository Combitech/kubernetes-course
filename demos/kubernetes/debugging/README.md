# Debugging Demo

## File Reader

Reads a file and prints it, again and again.

### Run

```shell
./file_reader.py hello_world.txt
```

### Build and publish

```shell
docker build -t combikubecourse.azurecr.io/demo/file_reader:1 -f Containerfile.file_reader .
docker push combikubecourse.azurecr.io/demo/file_reader:1
```

## Web server

### Run

```shell
./web_server.py
```

### Build and publish

```shell
docker build -t combikubecourse.azurecr.io/demo/web_server:1 .
docker push combikubecourse.azurecr.io/demo/web_server:1
```
