#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )/sh" && pwd )"

"${SH_DIR}/build_image.sh"
"${SH_DIR}/test_image.sh"
"${SH_DIR}/on_ci_publish_image.sh"
