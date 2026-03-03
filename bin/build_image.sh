#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source "${MY_DIR}/image_name.sh"

exists=$(docker buildx ls | grep container-builder | wc -l)

if [ $exists -eq 0 ]; then
docker buildx create \
    --name container-builder \
    --driver docker-container \
    --bootstrap \
    --use
fi

docker build \
  --builder container-builder \
  --platform linux/amd64,linux/arm64 \
  --tag $(image_name) \
  "${MY_DIR}/.."

docker build \
  --builder container-builder \
  --load \
  --platform linux/amd64 \
  --tag "$(image_name)" \
  "${MY_DIR}/.."
