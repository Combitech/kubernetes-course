# Starting point (some proper base image)
# See https://hub.docker.com/_/ubuntu for details
FROM ubuntu:22.04

# Ensure that required tools are installed
RUN apt update && apt install -y g++ cmake

# Copy files from host's file system into container image
COPY ./app /appdir

# Location _inside_ the container image
WORKDIR /appdir

# Build (according to instructions in the README)
RUN mkdir build && cd build && cmake .. && make

# Override application's default (5s here)
ENV APP_ITERATION_DELAY=5

# What to run when the container starts (by default)
ENTRYPOINT ["build/app"]
