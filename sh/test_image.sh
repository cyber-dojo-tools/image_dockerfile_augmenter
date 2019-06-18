#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
# don't create TMP_DIR off /tmp because on Docker Toolbox
# /tmp will not be available on the default VM
readonly TMP=$(cd ${MY_DIR} && mktemp -d XXXXXX)
readonly TMP_DIR=${MY_DIR}/${TMP}

remove_tmp_dir()
{
  rm -rf "${TMP_DIR}" > /dev/null;
}

trap remove_tmp_dir INT EXIT

assert_equals()
{
  local -r expected="${1}"
  local -r actual="${2}"

  if [ "${expected}" != "${actual}" ]; then
    echo "expected: ${expected}"
    echo "  actual: ${actual}"
    echo 'FAILED'
    exit 3
  fi
}

dockerfile_augmenter()
{
  cat "./Dockerfile" \
    | \
      docker run \
        --interactive \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        cyberdojofoundation/image_dockerfile_augmenter
}

cd ${TMP_DIR}
git clone https://github.com/cyber-dojo-languages/python.git
cd python
EXPECTED=$(cat "${MY_DIR}/expected.python.Dockerfile.augmented")
ACTUAL=$(dockerfile_augmenter)
assert_equals "${EXPECTED}" "${ACTUAL}"

cd ${TMP_DIR}
git clone https://github.com/cyber-dojo-languages/python-pytest.git
cd python-pytest
EXPECTED=$(cat "${MY_DIR}/expected.python-pytest.Dockerfile.augmented")
ACTUAL=$(dockerfile_augmenter)
assert_equals "${EXPECTED}" "${ACTUAL}"
