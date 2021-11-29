# Debugging Demo

## File Reader

Reads a file and prints it, again and again.

### Run

```shell
./file_reader.py hello_world.txt
```

### Build

```shell
podman build -t localhost:1234/file_reader:1 -f Containerfile.file_reader .
```

## Web server

### Run

```shell
./web_server.py
```

### Build

```shell
podman build -t localhost:1234/web_server:1 .
```
