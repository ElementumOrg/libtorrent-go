#!/bin/bash

function run() {
  { set +ex; } 2>/dev/null
  output=$("$@" 2>&1)
  ec=$?
  set -ex
  if [ ${ec} != 0 ]; then
    echo "Execution of '$*' failed:" >&2
    echo "${output}" >&2
    exit ${ec}
  fi
}
