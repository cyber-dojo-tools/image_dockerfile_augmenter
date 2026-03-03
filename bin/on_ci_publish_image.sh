#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source "${MY_DIR}/image_name.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images()
{
  if ! on_ci; then
    echo 'not on CI so not publishing image'
    return
  else
    echo 'on CI so publishing image'
  fi

  echo "Pushing $(image_name) to Container Registry"

  # PACKAGES_TOKEN and PACKAGES_USERNAME must be set in the Github Actions workflow
  echo "${PACKAGES_TOKEN}" | docker login ghcr.io -u "${PACKAGES_USERNAME}" --password-stdin

  docker buildx build \
   --push \
   --provenance=false \
   --platform linux/amd64,linux/arm64 \
   --tag $(image_name):latest \
    "${MY_DIR}/.."

  echo "Successfully pushed $(image_name) to Container Registry"

  docker logout
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ "${CI:-}" == 'true' ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images
