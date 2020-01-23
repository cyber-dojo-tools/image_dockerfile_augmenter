#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
# don't create TMP_DIR off /tmp because on Docker Toolbox
# /tmp will not be available on the default VM
readonly TMP=$(cd ${MY_DIR} && mktemp -d XXXXXX)
readonly TMP_DIR=${MY_DIR}/${TMP}
remove_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap remove_tmp_dir INT EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
assert_equals()
{
  local -r expected="${1}"
  local -r actual="${2}"
  if [ "${expected}" != "${actual}" ]; then
    echo '--------------------------------------------'
    echo expected
    echo "${expected}"
    echo '--------------------------------------------'
    echo actual
    echo "${actual}"
    echo '--------------------------------------------'
    echo 'FAILED: assert_equals()'
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dockerfile_augmenter()
{
  cat "./docker/Dockerfile.base" \
    | \
      docker run \
        --interactive \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        cyberdojotools/image_dockerfile_augmenter
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_base_language_repo()
{
  echo Checking python
  cd ${TMP_DIR}
  git clone https://github.com/cyber-dojo-languages/python.git
  cd python
  local -r expected=$(cat "${MY_DIR}/expected.python.Dockerfile.augmented")
  local -r actual=$(dockerfile_augmenter)
  assert_equals "${expected}" "${actual}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_test_framework_repo()
{
  echo Checking python-pytest
  cd ${TMP_DIR}
  git clone https://github.com/cyber-dojo-languages/python-pytest.git
  cd python-pytest
  local -r expected=$(cat "${MY_DIR}/expected.python-pytest.Dockerfile.augmented")
  local -r actual=$(dockerfile_augmenter)
  assert_equals "${expected}" "${actual}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_base_language_repo
check_test_framework_repo
