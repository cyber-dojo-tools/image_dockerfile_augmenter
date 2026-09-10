#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source "${MY_DIR}/image_name.sh"
readonly FIXTURES_DIR="${MY_DIR}/fixtures"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
assert_equals()
{
  local -r name="${1}"
  local -r expected="${2}"
  local -r actual="${3}"

  if [ "${expected}" == "${actual}" ]; then
    echo "PASSED: ${name}"
  else
    echo '--------------------------------------------'
    echo expected
    echo "${expected}"
    echo '--------------------------------------------'
    echo actual
    echo "${actual}"
    echo '--------------------------------------------'
    echo "FAILED: ${name}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
augmented()
{
  # Augments one fixture's Dockerfile.base, the way image_builder does.
  # The socket is mounted because the augmenter runs the FROM image to read
  # its /etc/issue.
  local -r fixture="${1}"

  cat "${FIXTURES_DIR}/${fixture}/Dockerfile.base" \
    | \
      docker run \
        --interactive \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        "$(image_name)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_fixture()
{
  # Each fixture holds the Dockerfile.base going in and the augmented
  # Dockerfile expected out. Both are committed here, so the test says the
  # same thing tomorrow as today.
  local -r fixture="${1}"

  echo "Checking ${fixture}"
  local -r expected=$(cat "${FIXTURES_DIR}/${fixture}/expected.Dockerfile.augmented")
  local -r actual=$(augmented "${fixture}")
  assert_equals "${fixture}" "${expected}" "${actual}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

check_fixture from-upstream-image
check_fixture from-cyber-dojo-image
