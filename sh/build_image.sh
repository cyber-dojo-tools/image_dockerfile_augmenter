#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

docker build \
  --tag cyberdojotools/image_dockerfile_augmenter \
  "${MY_DIR}/.."
