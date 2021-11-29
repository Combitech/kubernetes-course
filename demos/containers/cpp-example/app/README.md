# Example app C++ / CMake

## Prerequisites

* g++ (c++17)
* cmake (version >= 3)
* make

## How to build and run

### Prepare `build` directory

```shell
mkdir build
```

### Run CMake inside `build` directory

```shell
cd build
cmake ..
```

### Build application

```shell
make
```

### Run

```shell
./app
```

(Abort with CTRL-C)

> ***Run with assigned `APP_ITERATION_DELAY` environment variable***
>
> ```shell
> APP_ITERATION_DELAY=5 ./app
> ```