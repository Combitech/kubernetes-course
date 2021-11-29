#!/usr/bin/env bash

# Pull all base images used for the various dev-containers

set -eu # 👉 https://explainshell.com/explain?cmd=set+-eux

# Populate cache by building images based on the "FROM" part in an existing Dockerfile
# and then remove the image just built
function cache_baseimage_from_dockerfile {
  local ORG_DOCKERFILE=$1
  local TEMP_BUILD_DIR=/tmp/baseimage
  mkdir -p ${TEMP_BUILD_DIR}
  rm -rf ${TEMP_BUILD_DIR/*}

  echo "Extract baseimage definition from ${ORG_DOCKERFILE}:"
  cat ${ORG_DOCKERFILE} | grep -E "^FROM" | head -1 > ${TEMP_BUILD_DIR}/Dockerfile
  echo "->"
  cat -n ${TEMP_BUILD_DIR}/Dockerfile
  echo "---"
  docker build -t dummy:1 ${TEMP_BUILD_DIR}
  docker image rm dummy:1
  echo
}

function cache_baseimage_from_tag {
  local TAG=$1
  local TEMP_BUILD_DIR=/tmp/baseimage
  mkdir -p ${TEMP_BUILD_DIR}
  rm -rf ${TEMP_BUILD_DIR/*}

  echo "Create dummy Dockerfile for ${TAG}:"
  echo "FROM ${TAG:?}" > ${TEMP_BUILD_DIR}/Dockerfile
  echo "->"
  cat -n ${TEMP_BUILD_DIR}/Dockerfile
  echo "---"
  docker build -t dummy:1 ${TEMP_BUILD_DIR}
  docker image rm dummy:1
  echo
}

BASE_DIR=../

# "Clever" way of calling local function from "find"
# 👉 https://unix.stackexchange.com/a/50695
export -f cache_baseimage_from_dockerfile
find ${BASE_DIR} -type f '(' -name "Containerfile*" -o -name "Dockerfile*" ')' -exec bash -c 'cache_baseimage_from_dockerfile "$@"' bash {} \;

# Addtitional images
cache_baseimage_from_tag rabbitmq:4-management
cache_baseimage_from_tag rabbitmq:4-management-alpine
cache_baseimage_from_tag python:3.12
cache_baseimage_from_tag python:3.12-alpine
cache_baseimage_from_tag python:3.12-slim
cache_baseimage_from_tag golang:1.22
cache_baseimage_from_tag golang:1.22-alpine
cache_baseimage_from_tag ghcr.io/k3d-io/k3d-tools:5.8.3
cache_baseimage_from_tag ghcr.io/k3d-io/k3d-proxy:5.8.3
cache_baseimage_from_tag rancher/k3s:v1.32.4-k3s1
cache_baseimage_from_tag registry:2
