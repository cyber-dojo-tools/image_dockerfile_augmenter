#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
source "${MY_DIR}/image_name.sh"

docker build --tag $(image_name) "${MY_DIR}/.."
