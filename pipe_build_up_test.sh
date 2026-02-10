#!/usr/bin/env bash
set -Eeu

readonly BIN_DIR="$( cd "$( dirname "${0}" )/bin" && pwd )"

"${BIN_DIR}/build_image.sh"
"${BIN_DIR}/test_image.sh"
"${BIN_DIR}/on_ci_publish_image.sh"
